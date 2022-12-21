# Random Scripts by Ben

## Requirements

Install imagemagick, jpegoptim, pngquant and webp depending on which scripts you want to run

```
sudo apt-get update
sudo apt-get install imagemagick jpegoptim pngquant webp
```

## Usage

For **img-resize.sh**

`./img-resize.sh -p path/to/images --mtime -7 --dimension 2560`

For **img-optimize.sh**

`./img-optimize.sh -p path/to/images --mtime -7`

For **webp-converter.sh**

`./webp-converter.sh -p path/to/images`

Examples:

`./img-resize.sh -p /home/benrich/webapps/Ben-Rich/wp-content/uploads_opt/ --mtime -7 --dimension 1920`
`./img-optimize.sh -p /home/benrich/webapps/Ben-Rich/wp-content/uploads_opt/ --mtime -7300`
`./webp-converter.sh -p /home/benrich/webapps/Ben-Rich/wp-content/uploads_opt/`

### Deliver webp instead of jpg/png

To deliver webp files when jpgs or pngs are requested, essentially [follow this](https://docs.ewww.io/article/119-webp-delivery) from EWWW.

On RunCloud we edit the following for it to apply to all sites on the server:

- A webp mime type is already supported
- `/etc/nginx-rc/main-extra.conf` to add the file extension map
- The location block unfortunately needs to be done site by site. In RunCloud dashboard add a `deliver-webp` .conf file to `location.main-before` (remember to remove .gif as it's not supported)

## Troubleshooting

Make sure scripts are executable

```
chmod +x [path/to/file]
```
