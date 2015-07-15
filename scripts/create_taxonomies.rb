resources_folder = './scripts/resources/'
taxonomies_file = "#{resources_folder}taxonomies.json"
taxonomies = JSON.parse(File.read(taxonomies_file))

def import_taxonomy(taxonomies, parent_id, taxonomy_name)
  #return unless taxonomies.present? && taxonomies.is_a?(Hash)
  taxonomy = if taxonomy_name.present?
               name = taxonomy_name.split('#')
               Shoppe::ProductCategory.create!(:name => name[0],
                                               :permalink => name[1],
                                               :parent_id => parent_id)
             end
  parent_id = taxonomy.id rescue nil
  taxonomies.each do |k, v|
    import_taxonomy(v, parent_id, k)
  end
end

import_taxonomy(taxonomies, nil, nil)