require 'json'
require 'nokogiri'
heroes = [{
   first_name: 'Bruce',
   last_name: 'Wayne',
   nickname: 'Batman',
 },
 {
   first_name: 'Hal',
   last_name: 'Wayne',
   nickname: 'Green Lantern',
 }
]

heroes_json = JSON.parse(File.read("input.json"))

def save_to_json(heroes)
  File.open("input.json","w") do |f|
      f.write(heroes.to_json)
  end
end

def add_equipment(heroes_json)
  equipment = [["Batrang", "Grapling", "Hook", "Batmobile", "Utility belt"],
             ["Ring of Will", "Lantern"]]
  bat_equp = equipment[0]
  green_latern = equipment[1]

  heroes_json.map do |hero|
    if hero["nickname"] == "Batman"
     hero["equipment"] = [ bat_equp ]
    elsif hero["nickname"] == "Green Lantern"
     hero["equipment"] = [ green_latern ]
    end
  end
  heroes_json
end

heroes_equip = add_equipment(heroes_json)

def xml_convert(heroes_equip)
  a = []
  a << "<data>"
  heroes_equip.map do |hero|
    a << "<hero>"
    hero.map do |k,name|
      if hero[k].is_a?(Array)
        a << "<#{k}>"
        a << "<item>#{name.join("</item><item>")}"
        a << "</item>"
        a << "</#{k}>"
      else
        a << "<#{k}>#{name}</#{k}>"
      end
    end
    a << "</hero>"
  end
  a <<"</data>"
end
heroes_xml = xml_convert(heroes_equip).join('')

def save_to_xml(heroes_xml)
  doc = Nokogiri::XML(heroes_xml)
  File.write("output.xml", doc.to_xml)
end

save_to_xml(heroes_xml)
