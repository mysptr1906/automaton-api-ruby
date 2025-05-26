# Module JsonSchemaHelper
# This module provides a method to load JSON schemas from files and cache them for reuse.

module JsonSchemaHelper
  GLOBAL_SCHEMER_CACHE = {}
  
  def load_schemer(schema_name)
    GLOBAL_SCHEMER_CACHE[schema_name] ||= 
    begin
      schema_path = File.join(Dir.pwd, "json_schemas", "#{schema_name}.json")
      raise "Schema file not found: #{schema_path}" unless File.exist?(schema_path)

      schema_data = Oj.load(File.read(schema_path))
      JSONSchemer.schema(schema_data)
    end  
  end
end