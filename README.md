Chile in GeoJSON format
=======================

Taken from http://siit2.bcn.cl/mapas_vectoriales/index_html/

To convert from a shapefile object to GeoJSON use

```
ogr2ogr -f GeoJSON -t_srs crs:84 [output].geojson [input].shp
```

To pretty-print a Json file:

```
cat [input].geojson | python -mjson.tool
```

To pack a pretty printed file I'm using [Underscore](https://github.com/ddopson/underscore-cli):

```
underscore print --in [input].geojson --out [output].json --outfmt dense
```
