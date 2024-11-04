# RunBook - TAMS Example Media

Assumes:

* Using baked AMI

---

## Example Media

Big Buck Bunny media here

`/home/rocky/tams/examples/sample_content`

```
[rocky@ip-172-31-26-232 sample_content]$ la
total 235M
drwxrwxr-x. 2 rocky rocky  4.0K Nov  4 17:02 .
drwxrwxr-x. 3 rocky rocky  4.0K Nov  4 17:02 ..
-rw-rw-r--. 1 rocky rocky  1.5M Nov  4 17:02 hls_output0.ts
-rw-rw-r--. 1 rocky rocky  3.1M Nov  4 17:02 hls_output100.ts
-rw-rw-r--. 1 rocky rocky  3.2M Nov  4 17:02 hls_output101.ts
-rw-rw-r--. 1 rocky rocky  2.9M Nov  4 17:02 hls_output102.ts
```

---

## Mock API deploy

`cd /home/rocky/tams/examples/`

`. venv/bin/activate`

```
./outgest_file.py \
--tams-url https://squirrel-service/x-cloudfit/squirrelmediastore/v5.1 \
--username tams \
--password tams \
--flow-id eca3c5ff-d5b0-44b7-bd17-e58863f69bed \
--check-timing \
--output output.ts
```