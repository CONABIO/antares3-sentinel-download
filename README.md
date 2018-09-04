# antares3-sentinel-download

# Workflow to download Sentinel imagery for MAD-Mex

To obtain Sentinel images, you can consult them through the `dhusget.sh` script. For example, all the images available for Mexico between 2018-01-01 and 2018-08-01 could be searched as shown below:


```bash dhusget.sh -d https://scihub.copernicus.eu/dhus -u madmex -p madmex... -S 2018-01-01T00:00:00.000Z -E 2018-08-01T23:00:00.000Z -c -117.12,14.53:-86.81,32.7 -F 'platformname:Sentinel-2 AND producttype:S2MSI1C AND orbitdirection:DESCENDING' -q```


Where `<user>` and `<passwd>` are the credential for access in [Copernicus Open Access Hub](https://scihub.copernicus.eu/dhus/#/home). The rest of the parameters are to limit the search for a specific mission, in our case Sentinel-2, the initial and final dates in which the scene was taken, the type of product and finally the coordinates of opposite vertices of the bounding box of the region of interest, in our example Mexico. The `-q` parameter means that the result of the query will be saved in a xml file. For more details on the use of the script consult the following [link](https://scihub.copernicus.eu/userguide/BatchScripting). If you need help to determine the bounding box of a particular region, you can consult the following [page](https://boundingbox.klokantech.com/).

As a result of the search, all the available scenes for that period of time and region will be found in the OSquery-result.xml file, as shown below:

```
2018-09-04 13:31:40 (196 KB/s) - 'OSquery-result.xml' saved [75647]


     1	Displaying 0 to 24 of 41828 total results. Request done in 0.084 seconds.

     1	https://scihub.copernicus.eu/dhus/odata/v1/Products('2109b973-b52c-42c0-9cfb-e7f4a0d913c3')
     1	S2A_MSIL1C_20180801T181011_N0206_R084_T12SUA_20180801T234550
     2	https://scihub.copernicus.eu/dhus/odata/v1/Products('17747bac-f06e-413d-aec0-76f546c3cb1c')
     2	S2A_MSIL1C_20180801T181011_N0206_R084_T12RUV_20180801T234550
     3	https://scihub.copernicus.eu/dhus/odata/v1/Products('e139614a-c937-49d8-8ee5-8b29b8d27a4e')
     3	S2A_MSIL1C_20180801T181011_N0206_R084_T11RRJ_20180801T234550
     4	https://scihub.copernicus.eu/dhus/odata/v1/Products('b573de09-a413-4fb5-b5f2-9b312482737c')
     4	S2A_MSIL1C_20180801T181011_N0206_R084_T12SVB_20180801T234550
     5	https://scihub.copernicus.eu/dhus/odata/v1/Products('7ea5c8db-3a3d-44b4-83f2-1c1943ef7fc6')
     5	S2A_MSIL1C_20180801T181011_N0206_R084_T11RQN_20180801T234550
     6	https://scihub.copernicus.eu/dhus/odata/v1/Products('e461451f-eb0e-4cd4-bf38-c91830cd7ad7')
     6	S2A_MSIL1C_20180801T181011_N0206_R084_T12SUB_20180801T234550
     7	https://scihub.copernicus.eu/dhus/odata/v1/Products('27a03b00-67dc-48e1-bb28-24ec6f8f6df6')
     7	S2A_MSIL1C_20180801T181011_N0206_R084_T11SQR_20180801T234550
     8	https://scihub.copernicus.eu/dhus/odata/v1/Products('7b6d8c2f-5f64-43a8-913a-03d4aaa0d0e2')
     8	S2A_MSIL1C_20180801T181011_N0206_R084_T12STB_20180801T234550
     9	https://scihub.copernicus.eu/dhus/odata/v1/Products('31ad785f-9995-4267-a6a9-62d2efe0b0a0')
     9	S2A_MSIL1C_20180801T181011_N0206_R084_T12RTQ_20180801T234550
    10	https://scihub.copernicus.eu/dhus/odata/v1/Products('b8d4bc01-5e4b-4083-991f-ea9e5bdbc79a')
    10	S2A_MSIL1C_20180801T181011_N0206_R084_T11SPR_20180801T234550
    11	https://scihub.copernicus.eu/dhus/odata/v1/Products('2f3ce4db-09d0-48ee-b5fc-bff637564078')
    11	S2A_MSIL1C_20180801T181011_N0206_R084_T12RUT_20180801T234550
    12	https://scihub.copernicus.eu/dhus/odata/v1/Products('777d48e3-11b1-464c-8c3a-22ad1f128940')
    12	S2A_MSIL1C_20180801T181011_N0206_R084_T11RPN_20180801T234550
    13	https://scihub.copernicus.eu/dhus/odata/v1/Products('1b1df6f8-7d2e-4e91-8f2c-a6c3ae8ca924')
    13	S2A_MSIL1C_20180801T181011_N0206_R084_T12RVV_20180801T234550
    14	https://scihub.copernicus.eu/dhus/odata/v1/Products('bbb4ebbd-a2f4-4610-a420-13b0f30aa214')
    14	S2A_MSIL1C_20180801T181011_N0206_R084_T11RPP_20180801T234550
    15	https://scihub.copernicus.eu/dhus/odata/v1/Products('b88b7255-83d8-4328-917f-a8a3b01840b9')
    15	S2A_MSIL1C_20180801T181011_N0206_R084_T11RQM_20180801T234550
    16	https://scihub.copernicus.eu/dhus/odata/v1/Products('5017e60f-8ae1-438f-8476-b887b5cbfbc9')
    16	S2A_MSIL1C_20180801T181011_N0206_R084_T12SVA_20180801T234550
    17	https://scihub.copernicus.eu/dhus/odata/v1/Products('130a7a95-c1a1-45c0-ad53-c27a15cd4a91')
    17	S2A_MSIL1C_20180801T181011_N0206_R084_T11SQS_20180801T234550
    18	https://scihub.copernicus.eu/dhus/odata/v1/Products('127fcb1c-7b8a-4c64-938f-ff6ec58d1112')
    18	S2A_MSIL1C_20180801T181011_N0206_R084_T12STA_20180801T234550
    19	https://scihub.copernicus.eu/dhus/odata/v1/Products('3206be96-418b-4b84-a990-8099423b8d24')
    19	S2A_MSIL1C_20180801T181011_N0206_R084_T11RQK_20180801T234550
    20	https://scihub.copernicus.eu/dhus/odata/v1/Products('614c7901-0467-4ae8-8a5d-a5b221d2d719')
    20	S2A_MSIL1C_20180801T181011_N0206_R084_T11RPL_20180801T234550
    21	https://scihub.copernicus.eu/dhus/odata/v1/Products('d2ea2d10-203d-41cb-8b6d-7869579a9cc7')
    21	S2A_MSIL1C_20180801T181011_N0206_R084_T11RNM_20180801T234550
    22	https://scihub.copernicus.eu/dhus/odata/v1/Products('be3e06ce-4d1f-4dad-a545-b711014fee9f')
    22	S2A_MSIL1C_20180801T181011_N0206_R084_T12RTV_20180801T234550
    23	https://scihub.copernicus.eu/dhus/odata/v1/Products('cd7a044b-e6d6-4c94-8b9d-00df2783a943')
    23	S2A_MSIL1C_20180801T181011_N0206_R084_T12RTU_20180801T234550
    24	https://scihub.copernicus.eu/dhus/odata/v1/Products('9903100e-556f-425d-af3c-47e6fcab5c90')
    24	S2A_MSIL1C_20180801T181011_N0206_R084_T11RPM_20180801T234550
    25	https://scihub.copernicus.eu/dhus/odata/v1/Products('9b790f4a-ee08-402e-b09b-765dce498168')
    25	S2A_MSIL1C_20180801T181011_N0206_R084_T11RQQ_20180801T234550
the end
```










