#!/usr/bin/env ruby

require 'json'
require 'fileutils'
require 'stringex'

def format_str(input)
  if input.nil?
    return nil
  end
  input.downcase.to_ascii.gsub(' ', '_')
end

def consolidate_all_features(hash, header)
  hash.each do |k, v|
    p k
    group = {}
    group["crs"] = header
    group["features"] = v
    group["type"] = "FeatureCollection"
    output_file = File.new(k + "/all.geojson", "w+")
    output_file.truncate(0)
    output_file << group.to_json
  end
end

file = File.read('all.geojson')
data = JSON.parse(file)

header = data["crs"]

features_by_prov = {}
features_by_reg = {}

data["features"].each do |feature|
  props = feature["properties"]

  region = format_str(props["NOM_REG"])
  if region.nil?
    next
  end
  province = format_str(props["NOM_PROV"])
  county = format_str(props["NOM_COM"])

  dir = [region, province].join('/')
  FileUtils::mkdir_p dir

  features_by_reg[region] = [] if features_by_reg[region].nil?
  features_by_reg[region] << feature

  features_by_prov[dir] = [] if features_by_prov[dir].nil?
  features_by_prov[dir] << feature

  filename = [region, province, county + ".geojson"].join('/')
  p "Writing #{filename}"
  output_file = File.new(filename, "w+")
  output_file.truncate(0)

  value = {}
  feature["crs"] = header
  output_file << feature.to_json
end

p "Generating feature group"
consolidate_all_features(features_by_prov, header)
consolidate_all_features(features_by_reg, header)
