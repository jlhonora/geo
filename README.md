Chile in GeoJSON format
=======================

Taken from http://siit2.bcn.cl/mapas_vectoriales/index_html/

To convert from a shapefile object to GeoJSON use

```
ogr2ogr -f GeoJSON -t_srs crs:84 [output].geojson [input].shp
```

You can also simplify the input:

```
ogr2ogr -f "GeoJSON" -t_srs crs:84 -overwrite -progress -simplify 2000
```

and crop the precision of the waypoints:

```
sed -E -i 's/([0-9]{2}\.[0-9]{1,4})[0-9]*/\1/g'
```

(4 decimals will give you ~11 meters of precision)[http://en.wikipedia.org/wiki/Decimal_degrees].

To pretty-print a Json file:

```
cat [input].geojson | python -mjson.tool
```

To pack a pretty printed file I'm using [Underscore](https://github.com/ddopson/underscore-cli):

```
underscore print --in [input].geojson --out [output].json --outfmt dense
```
