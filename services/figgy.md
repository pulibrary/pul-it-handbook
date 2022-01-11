# Figgy

## Ingest from Isilon

Each of Figgy's servers has SMB mounts to a variety of places on the Isilon, all
under `/mnt/hydra_sources`. They are the following:

1. archives
    * Contains source TIFFs for digitized finding aids.
1. ingest_scratch
    * Working directory for Figgy developers to move content to in order to bulk
      ingest.
1. maplab
1. pudl
    * Contains source TIFFs for content found in PUDL. Primarily used for
      migrating to Figgy.
1. studio
    * Old studio staging server - not currently used for ingest.
1. studio_new
    * New studio staging server - the digitization studio saves images here for
      ingest into Figgy.

If you need to ingest content, the first step is to make sure the data is in one
of these shares. If it's new content, rather than being migrated, it should
ideally be in `ingest_scratch`. If you try to ingest from a location not in
these shares, background jobs will run on other servers which will be unable to
access the files. Currently content can be ingested in three
forms:

### Ingesting METS

Items coming from the PUDL consists of a METS file as well as a series of
images. The METS files have links to the source TIFFs and the mounts should be
set up appropriately. You can see an example METS file here:
[https://github.com/pulibrary/figgy/blob/186e13415d94223909800e651cf62d090ec1dcfd/spec/fixtures/mets/pudl0001-4609321-s42.mets](https://github.com/pulibrary/figgy/blob/186e13415d94223909800e651cf62d090ec1dcfd/spec/fixtures/mets/pudl0001-4609321-s42.mets). To ingest a METS file do the following:

1. `ssh deploy@lib-proc6`
2. `cd /opt/figgy/current`
3. `RAILS_ENV=production FILE=/mnt/hydra_sources/ingest_scratch/x/my_file.mets bundle exec rake import:mets`

### Ingesting Figgy Preservation Bags

Bagged materials currently do not have a rake task to import, will be coming
soon. Currently it's assumed that bag materials sit in a consistent location,
which will not be in `/mnt/hydra_sources`, since they're not used for ingest and
rather for recovery of exported materials.

### Ingesting by Directory

A directory structure can be set up to ingest an item. The directory
structure should look like this:

```
- 123456 #(bib-id)
  - 01.tif
  - 02.tif
```

For a Multi-volume Work it should look like the following:

```
- 123456 #(bib-id)
  - Volume 1
    - 01.tif
  - Volume 2
    - 02.tif
```

1. `ssh deploy@lib-proc6`
1. `cd /opt/figgy/current`
1. `RAILS_ENV=production bundle exec rake bulk:ingest
   DIR=/mnt/hydra_sources/ingest_scratch/x/123456 COLL=collid LOCAL_ID=local_id
   REPLACES=replaces`

`collid` should be the identifier in figgy of the collection you'd like to add
the item to. Optional.

`local_id` is a string representing some local identifier. Optional.

`replaces` is a string representing an old identifier of the item. Optional.

There is currently no way to pre-assign an ARK to an item being bulk ingested
(this is the `identifier` field in Figgy)

### Fixing Issues With Simple Tiles

Sometimes the `simple-tiles` library and the related `simpler-tiles` gem need to be reinstalled on Figgy machines. Here are the steps:

1. SSH into the machine as pulsys: `ssh pulsys@lib-proc2`
1. Run the following commands:

  ```
  $ sudo su deploy
  $ cd /opt/figgy/current
  $ bundle exec gem uninstall simpler-tiles
  $ exit
  $ sudo rm /usr/local/lib/libsimple-tiles.so
  $ curl -L https://github.com/propublica/simple-tiles/archive/v0.6.0.tar.gz | tar -xz && cd simple-tiles-0.6.0 
  $ ./configure && make
  $ sudo make install
  $ cd .. && sudo rm -r simple-tiles-0.6.0/
  ```
1. Redeploy Figgy to the server using Capistrano or Pulbot.

## Exporting Large Objects to Disk

When we need to share a large number of full-resolution files with a user, exporting all the files
attached to an object scales better than manually downloading each file. Use the
`figgy:export:files` Rake task to export an item, which also includes files attached to child
objects of MVWs. For example, for the Figgy object
https://figgy.princeton.edu/catalog/5a6e59c2-8b8d-4a70-bc6c-cad38e781636 has the
`source_metadata_identifier` C1384_c0289. To export this oobject, login to one of the lib-proc
machines as the `deploy` user and run the Rake task:

``` sh
cd /opt/figgy/current
bundle exec rake figgy:export:files ID=5a6e59c2-8b8d-4a70-bc6c-cad38e781636 FIGGY_EXPORT_BASE=/mnt/hydra_sources/ingest_scratch/export
```

The `ID` variable specifies the object to export, and the `FIGGY_EXPORT_BASE` variable overrides
the default export location to use Isilon-mounted storage to avoid filling up the local disk. This
exports the files in `/mnt/hydra_sources/ingest_scratch/export/C1384_c0289`, with a subdirectory
for each child volume, containing the files attached to that child.

It seems possible to mount Google Drive directly on a server, but we have not configured that. So
transferring a large amount of files requires downloading the files and then uploading them to
Google Drive. RSync is a good tool for downloading a large number of files because it can sync
whole directory trees and can resume transfers. To download the object above, I used this command:

``` sh
rsync -vaz lib-proc7.princeton.edu:/mnt/hydra_sources/ingest_scratch/export/C1384_c0289 .
```

Uploading to Google Drive works pretty well even for large volumes of files, and uploading 100GB
in this case completed in a few hours with no issues.
