## Processing Excercise

This exercise is intended to let you experience making sense of a body of archival material. Engaging in archival processing from the vantage point of archives practitioners will give you a first-row perspective of the data that results from this process (and that you'll ultimately be working with).

NB: While the collection material used in this exercise is real (and part of PUL's holdings), the collection history in the scenario below is fictional.

### Premise

Imagine you are a processing archivist. 
A curator in your Special Collections department just acquired a linear foot's worth of material and drops it off on your desk for processing.
The box is accompanied by a transfer slip from your institution's Art Museum. It indicates that the material was acquired by the museum from an auction house as part of a lot that also included an oil painting titled "French soldiers" by Baroness Hyde de Neuville.
The painting is the reason the museum acquired the lot; it transferred all other materials to Special Collections.

### Steps

1. **Do Not Panic.** Being faced with an archival collection for the first time can be disorienting. That's ok! Remember what you know about Context and take it into account as you go through. Also remember that the collection has passed through a few owners and is very likely at least a bit jumbled. There may not be much Context. That's ok too.

2. Quickly leaf through the materials to get a sense of the scope of the collection, without reading every document (contrary to common lore, that is not what archivists do all day! ;-) )
Take note of the following:
- [ ] Juxtaposition of materials. Can meaning be gleaned from it?
- [ ] Common denominators between materials. Focus on functional commonalities more than on format.
- [ ] Any information that ties the material to its provenance. There may or may not be any.
- [ ] Any information that explains why the whole body of material has been assembled as a whole.

3. Once you have a sense of what groups the materials might fall into, start assigning materials to them.
- [ ] Update your github repo so you have the files locally
    - [ ] We're working virtually, but let's pretend you're putting like materials into separate folders. I.e., create directories on your local machine and add documents that belong together to them.
    - [ ] Remind yourself that we're doing this because this is a highly disturbed collection (and for purposes of the exercise). In real life, and archivist might do very little or even no physical arrangement, especially if the material is already grouped in folders.
- [ ] Create a skeleton ArchivesSpace record with your groupings on the staging site.
- [ ] Start by creating a new Resource record:
    - [ ] Navigate to the `mss` directory (upper right)
    - [ ] `Create` a new `Resource` record (upper left)
    - [ ] Make it of type `collection` (drop-down)
    - [ ] Devise and enter a title for your collection ([DACS](https://saa-ts-dacs.github.io/dacs/06_part_I/03_chapter_02/03_title.html) may help!)
    - [ ] Determine and enter a date span (earliest and latest dates of documents in the collection)
    - [ ] Determine and enter the collection creator (if possible)
    - [ ] Enter a `Note` (`Notes` in the left-hand menu) of type `scopecontent`
    - [ ] Enter an `Extent` (`Extents` in the left-hand menu) with `Portion` set to whole (i.e., the extent statement applies to all of the material), `Number` set to "1" and `Type` set to "Box" (because the whole collection is in one box).
    - [ ] For purposes of this exercise, make up other required information (red asterisk) such as the collection identifier, and don't worry about filling out all (or even most) fields.
    - [ ] Save early and often!
- [ ] For each of the groups of materials that you have identified, create an Archival Object record linked to your Resource record:
    - [ ] In edit mode, select `add child`. This will bring up a new record template for the archival object record.
    - [ ] Make it of type `file`
    - [ ] Devise and enter a title for your group
    - [ ] Determine and enter a date span
    - [ ] Determine and enter the creator of the materials in the file (if possible; only do this if everything in the file has the same creator)
    - [ ] Enter a `Note` of type `scopecontent`
    - [ ] Enter fake information for other required fields as before
    - [ ] Save early and often!
- [ ] For each file, enter its physical location. We're pretending that the directories you created are physical folders, and that they will go into a box.
    - [ ] Go to `Instances` in the left-hand menu
    - [ ] Select `Add container instance`
    - [ ] Make it of `type`: `Mixed materials` (dropdown)
    - [ ] In the `Top Container` field, select `Create` from the dropdown (little arrow). This will bring up the template for a linked container record.
    - [ ] Make the container of `Container profile`: `NBox` (start typing and it'll pop up)
    - [ ] Give it `Container Type` of "Box" and an `Indicator` (aka number) "1" (since this is the one and only box in the collection)
    - [ ] In `Locations`, select `Current` for `Status` and the current date for `Start Date`, then enter `Firestone Library [scamss]` for the container location
    - [ ] Save early and often!
    - [ ] Go back to your Archival Object record and see how the Top_Container record now appears as a linked record in the `Instances` section.
- [ ] When you are satisfied with your finding aid (!), play around with the export buttons and look at the data you get back. Export as MARC, then as EAD. Have some fun recognizing your work serialized in different formats.
