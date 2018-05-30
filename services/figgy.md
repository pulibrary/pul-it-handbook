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
