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

`./webp-converter.sh path/to/images`

Examples:

`./img-resize.sh -p /home/benrich/webapps/Ben-Rich/wp-content/uploads_opt/ --mtime -7 --dimension 1920`
`./img-optimize.sh -p /home/benrich/webapps/Ben-Rich/wp-content/uploads_opt/ --mtime -7300`
`./webp-converter.sh /home/benrich/webapps/Ben-Rich/wp-content/uploads_opt/`

## Troubleshooting

Make sure scripts are executable

```
chmod +x [path/to/file]
```
