class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.references :article, index: true
      t.references :mentionee, index: true, polymorphic: true
    end
  end
end
