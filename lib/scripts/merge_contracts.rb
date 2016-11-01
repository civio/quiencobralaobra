# ruby merge_contracts.rb /Users/David/Box\ Sync/Civio/Proyectos/07\ Quién\ cobra\ la\ obra/02\ Data/Limpieza\ y\ análisis/ > 2009-2015.csv
# ruby merge_contracts.rb /Users/David/Box\ Sync/Civio/Proyectos/07\ Quién\ cobra\ la\ obra/02\ Data/Limpieza\ y\ análisis/ --split-UTEs > 2009-2015.split.csv

require 'roo'
require 'csv'
require 'slop'

# Read command line options
opts = Slop.parse do |o|
  o.banner = "usage: merge_contracts.rb [options]"
  o.bool '--split-UTEs', 'break down UTEs and duplicate contract records'
  o.on '--help', 'show help' do
    puts o
    exit
  end
end
$base_path = ARGV[0]

# Hardcoded list of input files. Will have to do for now.
files = [
  '2009/Obras 2009.xlsx',
  '2010/Obras 2010.xlsx',
  '2011/Obras 2011.xlsx',
  '2012/Obras 2012.xlsx',
  '2013/Obras 2013.xlsx',
  '2014/4 Obras 2014.xlsx',
  '2015/5 Obras 2015.xlsx',
]

# Calculate the joined list of header column names across a set of xls files
def get_consolidated_column_names(files)
  columns = []
  files.each do |filename|
    xlsx = Roo::Spreadsheet.open(File.join($base_path, filename))
    # We remove column names with names of the form "[...]": they are a bunch
    # of internal columns used during the manual process. Just noise.
    columns += xlsx.row(1).delete_if {|column| column =~ /^\[.+\]$/ }
  end

  # We inject a few extra columns, that we'll populate ourselves later on
  columns += [
      '[QCLO] Contratista - Limpio',
      '[QCLO] Contratista - Acrónimo',
      '[QCLO] Contratista - Grupo',
      '[QCLO] Descripción del objeto',
      '[QCLO] Entidad adjudicadora - Nombre',
      '[QCLO] Entidad adjudicadora - Tipo',
      '[QCLO] Es UTE',
      '[QCLO] Fecha de adjudicación',
      '[QCLO] Importe o canon de adjudicación - Limpio',
      '[QCLO] Procedimiento',
      '[QCLO] Procedimiento - Limpio',
      '[QCLO] Tramitación',
      '[QCLO] Tramitación - Limpio'
    ]

  columns.compact.sort.uniq
end

#
def get_column_value_by_name(row, column_names, column)
  position = column_names.index(column)
  if position.nil?
    ''
  else
    cell = row[position]
    # I don't fully understand how roo is returning the data: there seem
    # to be nil values for empty cells, which is ok. But also some sort
    # of Cell:Empty object, which returns nil when evaluated, something
    # the CSV generator doesn't like. So we double check:
    cell.nil? ? '' : (cell.value||'')
  end
end

# Read mapping data (names and UTEs breakdowns)
def get_name_mappings()
  name_mappings = {}
  utes_breakdown = {}
  valid_names = {}
  xlsx = Roo::Spreadsheet.open(File.join($base_path, 'Mapeo final nombres y UTEs.xlsx'), minimal_load: true)

  # Names
  xlsx.default_sheet = 'Nombres'
  xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
    original_name, amended_name, acronym, group = (row[0]&&row[0].value), (row[1]&&row[1].value), (row[4]&&row[4].value), (row[6]&&row[6].value)
    company_data = { name: amended_name, acronym: acronym, group: group }
    valid_names[amended_name] = company_data   # Overwriting again and again is ok, data should be consistent
    if original_name and original_name!=''
      name_mappings[original_name.downcase] = company_data  # Why downcase? See issue #37
    end
  end

  # UTEs
  xlsx.default_sheet = 'UTEs'
  xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
    ute, company = row[0].value, row[1].value
    next if company.nil? or company==''   # We're missing a few breakdowns still
    utes_breakdown[ute] ||= []
    utes_breakdown[ute].push company
  end

  return name_mappings, utes_breakdown, valid_names
end
$name_mappings, $utes_breakdown, $valid_names = get_name_mappings()

# Given a company name, return its data, possibly after fixing typos or misspellings
def get_company_details(original_name, id)
  return { name: original_name } if original_name==''   # Nothing to do

  # If the name is in the approved list, return its data
  return $valid_names[original_name] if $valid_names.include? original_name

  # Otherwise, fix the spelling and use the resulting name
  if $name_mappings.include? original_name.downcase
    $name_mappings[original_name.downcase]
  else
    $stderr.puts "**Missing name mapping at #{id}: [#{original_name}]"
    { name: original_name }
  end
end

# Read clean amount data (i.e. from dirty amounts to consistent well-formatted ones)
def get_amounts_mappings()
  amount_mappings = {}
  xlsx = Roo::Spreadsheet.open(File.join($base_path, '!2009-2015/amounts [manually cleaned].xlsx'), minimal_load: true)
  xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
    original_amount, amended_amount = row[1].value, row[2].value
    next if original_amount.nil? or original_amount==''
    amount_mappings[original_amount] = amended_amount
  end
  amount_mappings
end
$amount_mappings = get_amounts_mappings()

# Read clean award date data (i.e. from human dates to consistent well-formatted ones)
def get_award_date_mappings()
  award_date_mappings = {}
  xlsx = Roo::Spreadsheet.open(File.join($base_path, '!2009-2015/award dates [manually cleaned].xlsx'), minimal_load: true)
  xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
    original_date, amended_date = row[1].value, row[3].value
    award_date_mappings[original_date] = amended_date
  end
  award_date_mappings
end
$award_date_mappings = get_award_date_mappings()

# Read entities data (i.e. main controlling entity for a given name)
def get_entity_mappings()
  entity_mappings = {}
  valid_entities = {}

  xlsx = Roo::Spreadsheet.open(File.join($base_path, '!2009-2015/entities [manually cleaned].xlsx'), minimal_load: true)
  xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
    original_name, entity_type, entity_name = (row[0]&&row[0].value), (row[1]&&row[1].value), (row[2]&&row[2].value)
    entity_data = { entity_type: entity_type, entity_name: entity_name }
    valid_entities[entity_name] = entity_data   # Overwriting again and again is ok, data should be consistent
    if original_name and original_name!=''
      entity_mappings[original_name.downcase] = entity_data     # Why downcase? See issue #37
    end
  end

  return entity_mappings, valid_entities
end
$entity_mappings, $valid_entities = get_entity_mappings()

# Helper functions to get details from mappings above
def get_clean_bidder(row, column_names, id)
  original_name = get_column_value_by_name(row, column_names, '[QCLO] Contratista')
  get_company_details(original_name, id)
end

def get_bidder_group_name(bidder)
  # If we have no group info, use the original name. I.e. kind of a group of its own.
  # This simplifies analysis work down the line, since all the info we need is in one column.
  (bidder[:group] && bidder[:group]!='') ? bidder[:group] : bidder[:name]
end

def get_entity_data(row, column_names, id)
  section = get_column_value_by_name(row, column_names, 'Departamento')
  if $valid_entities.include? section
    # If we have a valid top level entity, that's it...
    return $valid_entities[section]
  else
    # ...otherwise map the low-level organization into a top level one
    original_entity = get_column_value_by_name(row, column_names, 'Entidad adjudicadora - Organismo')
    $stderr.puts "**Missing entity mapping at #{id}: [#{original_entity}]" unless $entity_mappings.include? original_entity.downcase
    return $entity_mappings[original_entity.downcase] || {}
  end
end

# Helper functions to get details about procedure type ('Tramitación' and 'Procedimiento')
def get_process_field(row, column_names, field)
  # The information can be found in a number of columns. We prioritize the 'Análisis' set
  analysis_info = get_column_value_by_name(row, column_names, "Análisis - #{field}")
  first_body_location = get_column_value_by_name(row, column_names, "Tramitación y procedimiento - #{field}")
  second_body_location = get_column_value_by_name(row, column_names, "Tramitación, procedimiento y forma de adjudicación - #{field}")
  return analysis_info=='' ?
          (first_body_location=='' ? second_body_location : first_body_location) :
          analysis_info
end

def guess_process_type(raw_value)
  if raw_value =~ /\babier|\bconcurso/i
    value = 'Abierto'
  elsif raw_value =~ /\bsin +pub/i
    value = 'Negociado sin publicidad'
  elsif raw_value =~ /\bnegociado +con +pub/i
    value = 'Negociado con publicidad'
  elsif raw_value =~ /\bnegociado/i
    value = 'Negociado'
  elsif raw_value =~ /\bdi[aá]logo/i
    value = 'Dialogo competitivo'
  elsif raw_value =~ /\brestringido/i
    value = 'Restringido'
  else
    value = ''
  end
end

def guess_process_track(raw_value)
  if raw_value =~ /\bo(rd|r|d)i+nar|\bnormal/i
    value = 'Ordinaria'
  elsif raw_value =~ /\bur?gen/i
    value = 'Urgente'
  elsif raw_value =~ /\bemergencia/i
    value = 'Emergencia'
  else
    value = ''
  end
end


# We precalculate the consolidated list of column names across all files...
consolidated_column_names = get_consolidated_column_names(files)

# ...so we can stream the data files and output the final result as we go.
puts CSV::generate_line(consolidated_column_names)
files.each do |filename|
  column_names = nil
  xlsx = Roo::Spreadsheet.open(File.join($base_path, filename), minimal_load: true)
  xlsx.each_row_streaming(pad_cells: true) do |row|
    # Read the column names from the first row
    if column_names.nil?
      column_names = row.map {|c| c.value}
      next
    end

    # For data rows, go through the consolidated column list and retrieve values.
    values = []
    id = get_column_value_by_name(row, column_names, '[QCLO] ID') # Used for warning messages
    next if id.nil? or id=='' # Can only happen on blank lines
    consolidated_column_names.each do |column|
      if column == '[QCLO] Contratista - Limpio'
        values.push get_clean_bidder(row, column_names, id)[:name]

      elsif column == '[QCLO] Contratista - Acrónimo'
        values.push get_clean_bidder(row, column_names, id)[:acronym]

      elsif column == '[QCLO] Contratista - Grupo'
        values.push get_bidder_group_name(get_clean_bidder(row, column_names, id))

      elsif column == '[QCLO] Descripción del objeto'
        # Description can come from any of two fields (but not both at the same time, we checked)
        first_location = get_column_value_by_name(row, column_names, 'Objeto del contrato - Descripción')
        second_location = get_column_value_by_name(row, column_names, 'Objeto del contrato - Descripción del objeto')
        description = first_location=='' ? second_location : first_location
        values.push description

      elsif column == '[QCLO] Entidad adjudicadora - Nombre'
        values.push get_entity_data(row, column_names, id)[:entity_name]

      elsif column == '[QCLO] Entidad adjudicadora - Tipo'
        values.push get_entity_data(row, column_names, id)[:entity_type]

      elsif column == '[QCLO] Es UTE'
        bidder = get_clean_bidder(row, column_names, id)[:name]
        values.push (($utes_breakdown.include? bidder) ? 'S' : 'N')

      elsif column == '[QCLO] Fecha de adjudicación'
        # The date can be in two different sections, depending on the year, so check both
        old_section = get_column_value_by_name(row, column_names, 'Adjudicación - Fecha')
        new_section = get_column_value_by_name(row, column_names, 'Formalización del contrato - Fecha de adjudicación')
        award_date = old_section=='' ? new_section : old_section

        # 
        if ( award_date.is_a? Date )
          # Since we're working with Excel as input, sometimes we get proper dates,...
          values.push award_date.to_s
        else
          # ...but often we just get a text string. We've cleaned and verified them beforehand.
          $stderr.puts "**Missing award date mapping at #{id}: [#{award_date}]" unless $award_date_mappings.include? award_date or award_date==''
          values.push $award_date_mappings[award_date] || award_date
        end

      elsif column == '[QCLO] Importe o canon de adjudicación - Limpio'
        original_amount = get_column_value_by_name(row, column_names, '[QCLO] Importe o canon de adjudicación')
        $stderr.puts "**Missing amount mapping at #{id}: [#{original_amount}]" unless $amount_mappings.include? original_amount or original_amount==''
        values.push $amount_mappings[original_amount] || original_amount

      # Returns the best guess for process type, based on available information across a number of fields.
      # See issue #50 for further details.
      elsif column == '[QCLO] Procedimiento'
        values.push get_process_field(row, column_names, 'Procedimiento')

      elsif column == '[QCLO] Procedimiento - Limpio'
        raw_value = get_process_field(row, column_names, 'Procedimiento')
        # Once we have a value, we need to try to understand it, as it's often dirty
        value = guess_process_type(raw_value)
        if value==''
          # Often process track and type are reversed, so try the other way around
          raw_value = get_process_field(row, column_names, 'Tramitación')
          value = guess_process_type(raw_value)

          # Last resort, look in the title
          if value==''
            title = get_column_value_by_name(row, column_names, 'Título')
            value = guess_process_type(title)
          end

          # If that fails just keep going, it's too unreliable to look in the whole body text (see #50)
        end
        values.push value

      # Same as with '[QCLO] Procedimiento'
      elsif column == '[QCLO] Tramitación'
        values.push get_process_field(row, column_names, 'Tramitación')

      elsif column == '[QCLO] Tramitación - Limpio'
        raw_value = get_process_field(row, column_names, 'Tramitación')
        # Once we have a value, we need to try to understand it, as it's often dirty
        value = guess_process_track(raw_value)
        if value==''
          # Often process track and type are reversed, so try the other way around
          raw_value = get_process_field(row, column_names, 'Procedimiento')
          value = guess_process_track(raw_value)

          # Last resort, look in the title, but be very specific, since 'ordinaria' is a common word
          # and there'd be false positives
          if value==''
            title = get_column_value_by_name(row, column_names, 'Título')
            value = 'Urgente' if title =~ /\bUrgente\b/i
          end

          # If that fails just keep going, it's too unreliable to look in the whole body text (see #50)
        end
        values.push value

      else 
        values.push get_column_value_by_name(row, column_names, column)
      end
    end

    # Output data row with columns matching the global list
    # (as long as there's something to print, ignore empty lines)
    if values.find{|value| value!=''}
      unless opts['split-UTEs']
        puts CSV::generate_line(values)
      else
        # If we're breaking the UTEs into their participant companies we need 
        # to do some convoluted transformations: instead of printing one line
        # we'll print as many as participant companies exist, replacing the
        # UTE name with each of them.
        # So, extract the company name from the list of values, ...
        company_name_position = consolidated_column_names.index('[QCLO] Contratista - Limpio')
        company_name = values[company_name_position]
        # ...check whether it's an UTE (if not, treat it as a single member UTE)...
        # Note: most of the companies are not UTEs, so warning on an unsuccessful match
        # triggers loads of false alarms. It's a good idea though to activate this
        # and then check manually at least once.
        # $stderr.puts "**Missing UTE breakdown at #{id}: [#{company_name}]" unless utes_breakdown.include? company_name
        participants = $utes_breakdown[company_name] || [company_name]
        # ...and print one line per each participant.
        participants.each do |participant|
          # Set the name of the participant...
          values[company_name_position] = participant

          # ...and its group and acronym.
          company_details = get_company_details(participant, id)

          acronym_position = consolidated_column_names.index('[QCLO] Contratista - Acrónimo')
          values[acronym_position] = company_details[:acronym]
          group_name_position = consolidated_column_names.index('[QCLO] Contratista - Grupo')
          values[group_name_position] = get_bidder_group_name(company_details)

          # Then generate the line
          puts CSV::generate_line(values)
        end
      end
    end
  end
end
