# Docker image R + Stata for Onyxia

## Purpose

Onyxia does not have Stata. This adds it.

## Build

### Adjust versions in the Dockerfile

The Dockerfile has a few version variables at the top. Adjust as needed. The base image is a Docker container that already runs on Onyxia, we are just adding as specific version of Stata. 

### Build it

```bash
docker build -t yourspace/image-name:image-tag .
```

### Push it

```bash
docker push yourspace/image-name:image-tag
```

## Configure Onyxia

### Add the Stata license

In your terminal, run 

```bash
cat /usr/local/statanow19/stata.lic | base64 -w 0
```

and copy the output. 

### Configure in Onyxia

IN Onyxia, got to "My Secrets", create a new folder, e.g., `Stata`. 

Then add a new variable, called `STATA_LIC_BASE64`. 

Paste the base64 string you just copied. Be sure that there are no spaces in the string.

### Configure an Onyxia service

Under "Service Catalog", select the `Rstudio` service. 

- Under `Docker image`, select `Custom image`, and add the path of your new container (`yourspace/image-name:image-tag`).
- Under `Vault`, add the "path" to your "secret"  in the field `Secret`, e.g., `Stata`. This makes all variables under that secret available to the service.
- Under `Init`, in the "User initialization script" field, add the raw URL to the initialization script. Replace `main` with your branch name if different:
  ```
  https://raw.githubusercontent.com/larsvilhuber/onyxia-test/main/init.sh
  ```
  This script will automatically configure the Stata license when the service starts.

You can optionally rename and save this configuration.

### Launch the service

Then launch the service. The Stata license will be automatically configured on startup using the initialization script.

**Note**: If you need to manually reconfigure the license, you can still run:
```bash
/usr/local/stata/statalic.sh
```


## Dropbox -> S3 data transfer

This image includes a simple bash function which serves to directly stream (large) files from a dropbox link into the S3 storage on your onyxia account:

```bash
dropbox_to_s3 "https://www.dropbox.com/s/xxx/file.zip" "uploads/20241435/file.zip"
```


## MATLAB

* matlab toolboxes list: https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/mpm-input-files/R2025b/mpm_input_r2025b.txt
* matlab on SSPcloud uses a custom image which has toolboxes pre-installed. currently I have
  ```
  Statistics_and_Machine_Learning_Toolbox \
    Optimization_Toolbox \
    Global_Optimization_Toolbox \
    Econometrics_Toolbox \
    Parallel_Computing_Toolbox \
    Signal_Processing_Toolbox \
    Symbolic_Math_Toolbox \
    Curve_Fitting_Toolbox \
    Financial_Toolbox
  ```
