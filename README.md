# sanitize
`sanitize` can be used to remove sensitive information from data.

# configuration
`sanitize` will apply a series of sed edits (defined by configuration files in ~/.config/sanitize) to the stdin data provided to the script.

A few examples of the configuration files can be found in `src/etc/`.

The edits will be applied in sorted order so it is recommended to start the file names with numbers in the order you want the edits to be applied.

# usage
The main use case for `sanitize` is to provide an easy way to clean log files before sharing them, e.g.
```
cat /path/to/my/file | sanitize > ~/log-to-be-uploaded.txt
```

# installation
The script can be installed directly from GitHub, e.g.
```
sudo curl -sS https://raw.githubusercontent.com/fontivan/sanitize/main/src/bin/sanitize -o /usr/local/bin/sanitize
sudo chmod +x /usr/local/bin/sanitize
```
