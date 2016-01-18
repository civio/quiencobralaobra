# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
admin = User.create!( name: 'Admin', 
                      email: 'admin@quiencobralaobra.es', 
                      password: 'password', 
                      password_confirmation: 'password')
eva = User.create!( name: 'Eva Belmonte', 
                      email: 'eva@civio.es', 
                      password: 'password', 
                      password_confirmation: 'password')


def create_mentions(article, mentionees)
  mentionees.map{|mentionee| Mention.create!({ article: article, mentionee: mentionee }) }
end

Article.delete_all
first_article = Article.create!({
    title: 'Las ilegalidades cotidianas de la contratación pública en España',
    lead: '<ul>
  <li>El informe de la contratación estatal de 2012 del Tribunal de Cuentas denuncia irregularidades en todos los ministerios</li>
  <li>Analiza 377 contratos de entre los de mayor precio</li>
  <li>Destaca el uso del negociado para formalizar acuerdos previos con un empresario y la falta de publicidad y justificación</li>
</ul>',
    author: eva,
    content: '<p>El BOE recoge hoy el <a href="http://boe.es/boe/dias/2015/10/23/pdfs/BOE-A-2015-11415.pdf#BOEn" target="_blank">informe de fiscalización a la contratación del sector público estatal de 2012</a> realizado por el Tribunal de Cuentas. El documento recoge -una vez mas- una larga lista de incumplimientos de la Ley de Contratos del Sector Público (<a href="https://www.boe.es/buscar/act.php?id=BOE-A-2011-17887&amp;tn=1&amp;p=20151002&amp;vd=#BOEn" target="_blank">LCSP</a>) por parte de todos los ministerios y otras entidades públicas. La mayoría tiene que ver con la falta de información y justificación de las decisiones tomadas, lo que <strong>frena la transparencia, la competencia y la rendición de cuentas</strong>.</p>

<p>De los <a href="http://rpc.meh.es/informes/informes2012/Estado/Estado_2012.html#BOEn" target="_blank">40.730 contratos</a> adjudicados por el Estado en 2012, el Tribunal de Cuentas <strong>recibió, para su fiscalización, 1.383 expedientes</strong>. Se trata de aquellos contratos que superen ciertos umbrales: más de 600.00 euros en obras y concesiones, más de 450.000 en suministros y más de 150.000 en servicios. Pese a que los contratos mas altos tienen unas obligaciones de transparencia, concurrencia e igualdad mayores, las irregularidades detectadas son masivas. <strong>Ni uno de los ministerios analizados sale limpio del análisis</strong>. Pero el Tribunal de Cuentas <strong>no ha analizado los 1.383 expedientes remitidos, solo 377 de ellos</strong>, un 27,3%, elegidos según diversos criterios, como la cuantía, el procedimiento y otros valores mucho menos definidos, como “el especial interés”.</p>

<p>Estas son algunas de las ilegalidades detectadas por el Tribunal de Cuentas:</p>

<ul>
  <li>
    <p>Falta de justificación del uso del <strong>procedimiento negociado</strong>, ya que en muchos casos no queda claro por qué se opta por este sistema y no por el concurso abierto que, según la propia ley, debe ser el método ordinario de adjudicación. En la mayoría de casos, continúa el informe, no se “negocia” con los empresarios participantes, simplemente se evalúan sus ofertas, lo que hace que este procedimiento pierda su sentido. Además, en ocasiones se usa simplemente <strong>para darle una pátina legal a un acuerdo con un empresario</strong>: “En determinados supuestos, las Entidades han justificado la elección de este procedimiento por la existencia de un acuerdo previo firmado con la empresa adjudicataria debido a la complejidad técnica de las prestaciones a realizar, y si bien pudiera estar justificada la elección del procedimiento por razones técnicas, la existencia de un acuerdo previo limita, al menos, el acceso de otras empresas del sector a la licitación.”</p>
  </li>
  <li>
    <p>Uso de las <strong>características de la empresa como criterios de adjudicación</strong>, lo que limita la competencia y hace pensar en <strong>pliegos redactados a medida</strong>. Ocurre cuando se puntúa de forma elevada contar con ciertos trabajadores, tener la sede en un lugar concreto… El informe destaca un contrato de la Agencia Española de Protección de Datos (AEPD) que otorgaba un 15% de la valoración a las empresas que hubieran realizado un servicio similar en los años anteriores, lo que benefició a la empresa que ya estaba contratada, que pudo volver a ser elegida. Otro caso paradigmático de esta práctica, anulado por el Tribunal administrativo central de recursos contractuales tras un recurso, es el del <a href="http://elboenuestrodecadadia.com/2015/05/27/el-gobierno-anula-los-pliegos-de-la-publicidad-institucional-en-prensa-de-melilla/" target="_blank">reparto de la publicidad institucional en prensa de Melilla</a>, redactado a medida para que los tres principales periódicos de la ciudad se llevaran su parte.</p>
  </li>
  <li>
    <p><strong>Falta de precisión de los criterios de adjudicación</strong>, como cuando se conceden puntos por “mejoras” sin especificar qué tipo de mejoras serán evaluadas y en qué proporción, lo que da pie a la <strong>arbitrariedad en la concesión</strong>. En demasiadas ocasiones, las actas de adjudicación tampoco aclaran qué se ha valorado para ofrecer, al final, una tabla de puntuación si más, esto es, no informan de las razones que les llevan a adjudicar a un empresario y no a otro.</p>
  </li>
  <li>
    <p><strong>Incumplimiento sistemático de las obligaciones de igualdad entre hombres y mujeres</strong>, que obligan a tener en cuenta los planes en este sentido y la efectiva implantación de los mismos de las empresas a contratar.</p>
  </li>
  <li>
    <p><strong>Límites a las rebajas de precio</strong>, lo que se conoce como el ‘umbral de saciedad’: a partir de cierto descuento en el precio, las rebajas posteriores ya no dan puntos. Esta práctica frena que las empresas puedan ofrecer contratos más baratos.</p>
  </li>
  <li>
    <p><strong>No se justifica por qué es necesario celebrar el contrato</strong>. En muchos casos, no hay informes de necesidad ni en los que se declara que los medios propios no son suficientes para hacer frente a las necesidades.</p>
  </li>
  <li>
    <p><strong>Incumplimiento de las obligaciones de publicidad básicas</strong>. Por ejemplo, la AEPD solo publicó en Contratación del Estado uno de los 23 contratos celebrados durante ese año. Y el Programa de Termalismo de Mayores se olvidó de publicar la formalización de un contrato en el BOE. En muchas ocasiones, el problema es que los pliegos de algunos negociados ni siquiera aclaran cuál es el objeto del contrato.</p>
  </li>
  <li>
    <p>Tras la adjudicación, ¿qué pasa? En la mayoría de casos, nada. Una de las críticas mas repetidas en el informe está dirigida al <strong>escaso control a la ejecución de los contratos</strong>. No se nombra a un responsable del contrato para hacer seguimiento, aunque esté establecido de forma clara en los pliegos, no hay vigilancia de ningún tipo… Esto provoca <strong>excesos en la facturación final y retrasos</strong> que, en la mayoría de casos, no provocan ni la resolución del contrato ni la aplicación de las sanciones previstas. En muchos casos, el organismo adjudicador no informa al Tribunal sobre lo que pasó tras la adjudicación: ni siquiera disponen de esa documentación.</p>
  </li>
</ul>

<p>El informe del Tribunal de cuentas lanza una serie de propuestas de mejora pero, pese a las continuas ilegalidades cometidas, no plantea el establecimiento de ningún tipo de sanción.</p>

<hr>

<p><strong>Esto es solo un avance</strong>. El próximo otoño verá la luz <em>¿Quién cobra la obra?</em>, el próximo proyecto de Civio, en el que vamos a analizar el uso del negociado en las administraciones públicas. Los datos de este artículo, extraídos de <a href="https://contrataciondelestado.es/wps/portal/plataforma">Contratación del Estado</a>, son todos los contratos -a excepción de los menores- adjudicados en 2013 y 2014 por todos los ministerios. Para realizar un análisis más profundo del uso de este procedimiento, deberíamos -y lo haremos- añadir la cuantía de esas adjudicaciones y analizar, caso por caso, <a href="http://quiencobralaobra.es/lo-que-dice-la-ley-sobre-el-uso-del-negociado/">si se ajustan a la ley</a>. Por desgracia, las razones que se argumentan para que un contrato específico se adjudique por negociado no son públicas, así que solo podremos escudriñar a fondo los más cuantiosos, aquellos que solo por precio no pueden entrar dentro de esta categoría.</p>

<p>En <em>¿Quién cobra la obra?</em> <strong>vamos a sumar al análisis a las comunidades autónomas, entidades locales y otros organismos públicos</strong>, utilizando varias fuentes públicas. Además vamos a ampliar la investigación a <strong>otros años</strong>, para estudiar la diferencia entre gobiernos y, lo más importante, vamos a <strong>poner luz sobre qué empresas se han llevado los contratos de obra pública</strong> en nuestro país. Son los primeros pasos de una nueva aventura. En Civio vamos a sumergirnos, de lleno, en la contratación pública, protagonista de muchos de los casos de corrupción de los últimos años.</p>',
    photo_footer: 'Lorem ipsum pie de foto',
    photo_credit: 'El autor',
    photo_credit_link: 'http://google.com',
    published: true,
    publication_date: '12/9/2015'
  })
first_article.photo.store!(File.open(File.join(Rails.root, 'db', 'seed_files', 'foo.png')))
first_article.save!
# first_article.mentions_in_content = create_mentions(first_article, [first_body, first_bidder])

second_article = Article.create!({
    title: 'El 60% de los contratos de los ministerios en 2014 se adjudicaron sin concurso',
    lead: '<p>En el último año, de los <strong>7.237</strong> contratos adjudicados, solo 2.889 lo fueron vía concurso abierto</p><div id="home-chart"></div>',
    author: eva,
    content: '<p>La Ley de Contratos del Sector Público es clara: <a href="https://www.boe.es/buscar/act.php?id=BOE-A-2011-17887&amp;tn=1&amp;p=20150331&amp;vd=#a138">“La adjudicación se realizará, ordinariamente, utilizando el procedimiento abierto o el procedimiento restringido”</a>. ¿Se cumple? En lo que respecta a los ministerios y, en los últimos dos años, no. Tanto en 2013 como en 2014, el 60% de los contratos se adjudicaron vía negociado, <strong>la gran mayoría sin publicidad</strong>.</p>

<iframe width="800" height="400" src="//embed.chartblocks.com/1.0/?c=55b635a9c9a61d3f644a153e&amp;t=9a6b7c9fc8a91bb" frameborder="0"></iframe>

<p>En concreto, en el último año, de los <strong>7.237</strong> contratos adjudicados, solo 2.889 lo fueron vía concurso abierto y <strong>4.301 se concedieron por negociado, 4.093 de ellos sin publicidad</strong>. El resto, un porcentaje mínimo (0,65%), se dirimió vía procedimiento restringido o normas internas.</p>

<p>Uno de los ministerios que cuenta con un porcentaje mayor de negociados es <strong>Defensa</strong>, con casi un 71%. También es el departamento que más contratos adjudicó en 2014, un total de <strong>2.389</strong>, frente a los 57 de Justicia o los 88 de <strong>Asuntos Exteriores y Cooperación</strong>. Este último es el que <strong>se lleva la palma en cuanto al uso del negociado, un 82%</strong> frente a un 18% de concursos. También superan la media el <strong>Ministerio de Educación, Cultura y Deporte (70%)</strong> y el de <strong>Presidencia (73%)</strong>.</p>

<p>Al otro lado, los ministerios en los que el número de adjudicaciones por concurso es mayor son Agricultura, Alimentación y Medio Ambiente (64,05% por concurso); Empleo y Seguridad Social (57,10%); y el Ministerio de Justicia (68,42%).</p>

<hr>

<p><strong>Esto es solo un avance</strong>. El próximo otoño verá la luz <em>¿Quién cobra la obra?</em>, el próximo proyecto de Civio, en el que vamos a analizar el uso del negociado en las administraciones públicas. Los datos de este artículo, extraídos de <a href="https://contrataciondelestado.es/wps/portal/plataforma">Contratación del Estado</a>, son todos los contratos -a excepción de los menores- adjudicados en 2013 y 2014 por todos los ministerios. Para realizar un análisis más profundo del uso de este procedimiento, deberíamos -y lo haremos- añadir la cuantía de esas adjudicaciones y analizar, caso por caso, <a href="http://quiencobralaobra.es/lo-que-dice-la-ley-sobre-el-uso-del-negociado/">si se ajustan a la ley</a>. Por desgracia, las razones que se argumentan para que un contrato específico se adjudique por negociado no son públicas, así que solo podremos escudriñar a fondo los más cuantiosos, aquellos que solo por precio no pueden entrar dentro de esta categoría.</p>

<p>En <em>¿Quién cobra la obra?</em> <strong>vamos a sumar al análisis a las comunidades autónomas, entidades locales y otros organismos públicos</strong>, utilizando varias fuentes públicas. Además vamos a ampliar la investigación a <strong>otros años</strong>, para estudiar la diferencia entre gobiernos y, lo más importante, vamos a <strong>poner luz sobre qué empresas se han llevado los contratos de obra pública</strong> en nuestro país. Son los primeros pasos de una nueva aventura. En Civio vamos a sumergirnos, de lleno, en la contratación pública, protagonista de muchos de los casos de corrupción de los últimos años.</p>',
    photo_footer: 'Lorem ipsum pie de foto',
    photo_credit: 'El autor',
    photo_credit_link: 'http://google.com',
    published: true,
    highlighted: true,
    publication_date: '20/9/2015'
  })
# second_article.mentions_in_content = create_mentions(first_article, [first_bidder, second_bidder, third_bidder])

third_article = Article.create!({
    title: 'Lo que dice la ley sobre el uso del negociado',
    lead: 'Lorem Ipsum Blah Blah',
    author: eva,
    content: '<p>El <a href="http://quiencobralaobra.es/el-60%25-de-los-contratos-de-los-ministerios-en-2014-se-adjudicaron-sin-concurso/">60%</a> de los contratos de los ministerios en los últimos dos años se han adjudicado sin concurso, vía negociado. Pero, ¿en qué consiste y qué significa en términos de transparencia e igualdad de acceso? ¿Cuándo se puede usar?</p>

<h4 id="qu-es-un-negociado">¿Qué es un negociado?</h4>
<p>Es un tipo de procedimiento en el que, en lugar de licitar un contrato de forma abierta y pública, se elige al adjudicatario tras consultar con diversos candidatos. Es obligatorio solicitar al menos tres ofertas <a href="https://www.boe.es/buscar/act.php?id=BOE-A-2011-17887&amp;tn=1&amp;p=20150331&amp;vd=#a169">“siempre que sea posible”</a>.</p>

<p>Dentro de los negociados, la normativa distingue entre aquellos <strong>con publicidad</strong> (se anuncia su licitación en los perfiles del contratante y en los boletines oficiales) o <strong>sin publicidad</strong> (no se anuncia y, por lo tanto, no podemos conocer la letra pequeña, esencial en muchísimos casos, los pliegos). La mayoría se adjudican sin publicidad.</p>

<h4 id="cundo-se-puede-usar">¿Cuándo se puede usar?</h4>
<p>La norma, que da prioridad al procedimiento abierto y el restringido, establece <strong>ciertas excepciones que permiten elegir el negociado</strong>. Aunque la versión simple marca ciertos <strong>umbrales económicos de entrada</strong> -pueden usarlo aquellos menores a 100.000 euros, excepto en contratos de obras (un millón) y de gestión de servicios públicos (medio millón)-, la realidad es algo más compleja. Más allá de esas especificaciones económicas, existen <strong>multitud de caminos para poder utilizar el procedimiento negociado en contratos de cuantías mucho más altas</strong>.</p>

<h5 id="en-todo-tipo-de-contratos">En todo tipo de contratos:</h5>

<ul>
  <li>Si falla el concurso abierto porque no se presenta nadie, se presentan empresarios incapacitados o sus propuestas incluyen valores anormales.</li>
  <li>En casos excepcionales en lo que las características del contrato no permiten determinar el precio final con antelación.</li>
  <li>En los que, por razones técnicas, artísticas o de protección intelectual, solo pueda concederse a una persona o empresa.</li>
  <li>Por <strong>“imperiosa urgencia”</strong> que no se pueda solventar solo acudiendo a la tramitación urgente. Eso sí, esa urgencia no puede ser imputable al organismo. Así, <strong>si una administración se retrasa a la hora de convocar un contrato, no puede utilizar este punto para salvar los muebles</strong>.</li>
  <li>En contratos secretos o reservados.</li>
  <li>Vinculados a la seguridad o el <strong>comercio de armas</strong>, según el artículo 346 del Tratado de funcionamiento de la UE.</li>
</ul>

<h5 id="en-contratos-de-obra">En contratos de obra:</h5>
<ul>
  <li>Si el valor estimado es menor a <strong>un millón de euros</strong>.</li>
  <li>En obras que se realicen únicamente con fines de investigación.</li>
  <li>En <strong>ampliaciones que no estén en el contrato inicial</strong> y sea necesario adjudicarlas a la misma empresa. Eso sí, tienen que se ampliaciones que no se pudieron preveer y no pueden suponer un valor de más de la mitad del contrato inicial.</li>
  <li>Repetición de obras similares ya adjudicadas a la misma empresa. Eso sí, esa posibilidad tiene que estar contemplada en el contrato inicial y no pueden haber pasado más de tres años desde que éste se firmó.</li>
</ul>

<h5 id="en-contratos-de-gestin-de-servicios-pblicos">En contratos de gestión de servicios públicos:</h5>
<ul>
  <li>Aquellos con un valor menor de medio millón y una duración que no supere los cinco años.</li>
  <li>La prestación de <strong>asistencia sanitaria concertada bajo convenio o acuerdo marco</strong>.</li>
</ul>

<h5 id="en-contratos-de-suministros">En contratos de suministros:</h5>
<ul>
  <li>Si el valor estimado es <strong>menor a 100.000 euros</strong>.</li>
  <li>Para la adquisición de Bienes Muebles del Patrimonio Histórico Español.</li>
  <li>Destinados de forma exclusiva a fines de investigación.</li>
  <li>Para reponer o ampliar suministros de un mismo empresario, pero solo en el caso de que cambiar de proveedor suponga un problema grave.</li>
  <li>Contratos concertados por cese de actividad de la empresa o concursos procesales en los que, por tanto, el precio sea muy ventajoso para la administración.</li>
</ul>

<h4 id="en-contratos-de-servicios-y-el-resto">En contratos de servicios y el resto:</h4>
<ul>
  <li>Si el valor estimado es <strong>menor a 100.000 euros</strong>.</li>
</ul>

<p><strong>NOTA IMPORTANTE</strong>: Estas son las condiciones necesarias para poder utilizar el procedimiento negociado, pero la entidad adjudicadora puede o no optar por él. Es decir, aunque cumpla alguno de estos puntos, puede decidir  licitarlo por concurso público. No es obligatorio. Aunque lo parezca por el uso masivo que se hace de él.</p>

<h3 id="una-reforma-que-nunca-llega">Una reforma que nunca llega</h3>

<p><strong>Todo esto cambiará en unos meses</strong>, en cuanto se apruebe la reforma de la Ley de Contratos del Sector Público, en la actualidad en trámite parlamentario. Una de las modificaciones que incluye esta norma, aun en <a href="http://www.minhap.gob.es/Documentacion/Publico/NormativaDoctrina/Proyectos/Borrador%20Anteproyecto%20de%20Ley%20de%20Contratos%20del%20Sector%20P%C3%BAblico-%2017%20abril%202015.pdf">borrador</a>, eliminará la posibilidad de utilizar el procedimiento negociado en los supuestos de precio (valores inferiores a ciertos umbrales).</p>

<p>Pero, <strong>¿cuándo llegará?</strong> La reforma transpone una <a href="http://www.minhap.gob.es/Documentacion/Publico/NormativaDoctrina/Contratacion/OJ_L_2014_094_FULL_ES_TXT.pdf">directiva europea</a> aprobada en marzo de 2014, que marca su aplicación por parte de los estados miembros con una fecha límite, el 18 de abril de 2016. Aunque hace meses que el Gobierno trabaja en el documento, no lo dejará aprobado antes del fin de legislatura. Eso es lo que <a href="http://tuderechoasaber.es/es/request/1828/response/2280/attach/3/Notificacion%20001%20001845%20003654%20csv.pdf">ha respondido</a> el Ministerio de Hacienda y Administraciones Públicas a una pregunta sobre su tramitación remitida a través de Tu Derecho a Saber.</p>

<p>En concreto, aunque aseguran que se cumplirá el plazo marcado por la UE, afirman que el proceso parlamentario <strong>“previsiblemente no finalizará antes del año 2016”</strong>. Así, serán Las Cortes que se formen tras las próximas elecciones generales las encargadas de tramitar y aprobar esta norma esencial.</p>

<hr>
<p><strong>Esto es solo un avance</strong>. <em>¿Quién cobra la obra?</em>, un proyecto que verá la luz en otoño, va a incluir una <strong>guía práctica de la Ley de Contratos del Sector Público</strong>, una de las más complejas de nuestra legislación, para que todos podamos tener claras las <strong>reglas del juego</strong> en solo unos minutos y de forma clara. Una guía que, además, se pondrá al día cuando entre en vigor la reforma que está en Las Cortes.</p>

<p>En <em>¿Quién cobra la obra?</em> vamos a analizar el uso del negociado en la <a href="http://quiencobralaobra.es/el-60%25-de-los-contratos-de-los-ministerios-en-2014-se-adjudicaron-sin-concurso/">Administración General del Estado</a>, comunidades autónomas, entidades locales y otros organismos públicos y, lo más importante, vamos a <strong>poner luz sobre qué empresas se han llevado los contratos de obra pública</strong> en nuestro país. Son los primeros pasos de una nueva aventura. En Civio vamos a sumergirnos, de lleno, en la contratación pública, protagonista de muchos de los casos de corrupción de los últimos años.</p>',
    photo_footer: 'Lorem ipsum pie de foto',
    photo_credit: 'El autor',
    photo_credit_link: 'http://google.com',
    published: true,
    publication_date: '4/10/2015'
  })
# third_article.mentions_in_content = create_mentions(first_article, [first_body, second_body])
third_article.photo.store!(File.open(File.join(Rails.root, 'db', 'seed_files', 'foo.png')))
third_article.save!

Article.create!({
    title: 'Lo que siempre quisiste saber sobre la contratación pública',
    lead: 'Lorem Ipsum Blah Blah',
    author: eva,
    content: 'Lorem Ipsum Blah Blah. Lorem Ipsum Blah Blah. Lorem Ipsum Blah Blah. Lorem Ipsum Blah Blah.',
    photo_footer: 'Lorem ipsum pie de foto',
    photo_credit: 'El autor',
    photo_credit_link: 'http://google.com',
    published: false,
    publication_date: '14/10/2015'
  })

