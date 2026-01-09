# ServiceNow tips and tricks

## Useful links

[Unassigned tickets for Ops](https://princeton.service-now.com/now/nav/ui/classic/params/target/task_list.do%3Fsysparm_query%3Dassignment_group%253Ddfef0cf74f800b40b1eaf7e18110c7c1%255Eactive%253Dtrue%255Eassigned_to%253D%26sysparm_first_row%3D1%26sysparm_view%3D) - for "grabbing" tickets
[Generic Request Form](https://princeton.service-now.com/service?id=sc_cat_item&sys_id=d93521720fcf820033f465ba32050ee5) - for creating new tickets
[List of all network objects](https://princeton.service-now.com/now/nav/ui/classic/params/target/u_infoblox_networks_list.do%3Fsysparm_userpref_module%3D62d2d4244ff85f00f56c0ad14210c7c4%26sysparm_query%3Doperational_status%253D1%255EEQ) - for finding IP ranges

## ServiceNow views

ServiceNow offers two ways to access information its database: "canned" views (also known as the Service Portal) and "bare-bones" (also called Classic UI) views. The two views offer different UIs, different options, and different default data sets. You can navigate from "canned" / Service Portal views to the "bare bones" / Classic UI by selecting `Switch to Classic UI` in the `My Account` menu. You cannot navigate the other direction (at least, not easily). Here's a single ticket shown both ways:

- ["canned" view of a ticket](https://princeton.service-now.com/service?id=ticket&sys_id=db679830874149107f147487cebb35f7&table=sc_req_item).

- ["bare-bones" view of the same ticket](https://princeton.service-now.com/nav_to.do?uri=%2Fsc_req_item.do%3Fsys_id%3Ddb679830874149107f147487cebb35f7%26sysparm_record_target%3Dsc_req_item%26sysparm_record_row%3D1%26sysparm_record_rows%3D1%26sysparm_record_list%3DnumberCONTAINS335118%255EORDERBYnumber).

Here's a view of tickets assigned to you, shown both ways:

- ["canned" view of My Work](https://princeton.service-now.com/now/workspace/agent/home)

- ["bare bones" view of My Work](https://princeton.service-now.com/nav_to.do?uri=%2Ftask_list.do%3Fsysparm_userpref_module%3D1523b8d4c611227b00be8216ec331b9a%26sysparm_query%3Dactive%253Dtrue%255Eassigned_to%253Djavascript%253AgetMyAssignments%2528%2529%255EEQ%26sysparm_clear_stack%3Dtrue)

# Using "canned" ServiceNow views

ServiceNow offers quite a few "canned" or default views linked to your login that can be helpful. Here are some sample "canned" views:

- https://princeton.service-now.com/service?id=tickets
  - by default, this view shows active tickets you created
  - with a single click, it can show closed tickets you created

- https://princeton.service-now.com/service?id=my_bookmarks
  - by default, this view shows bookmarked services
  - with a single click, it can show bookmarked forms

The "canned" views mostly show the perspective of a requester - someone reporting work for others to do. However, you can view work assigned to you by selecting `Switch to Workspace` in the `My Account` menu.

There is probably a way to do everything in ServiceNow in either view, but searching for tickets other people created, or tickets assigned to a group is often easier in the "bare-bones" view of ServiceNow.

## Using "bare-bones" ServiceNow views and searching

ServiceNow also offers a "bare-bones" view that allows more flexibility. You can access the entry point for the "bare-bones" view here:

https://princeton.service-now.com/

By default, this view is empty.

To search, start with the `Filter navigator` in the upper left corner. If you know what `type` of ticket you are searching for, you can list all tickets of that type. For example:

- To search for Incidents: type `incident.list` in the Filter navigator and hit Enter, then wait.
- To search for Requested items: type `sc_req_item.list` in the Filter navigator and hit Enter, then wait.

In our ServiceNow environment, most tickets opened by OIT are 'Incidents', while tickets opened from ServiceNow forms are 'Requested items'. There are probably other ticket types. It helps to have an existing ticket as an example - the URL of an example "canned" view can provide helpful clues about the ticket type.

Once you have a list of the type of ticket you want, you can filter the results by searching within the various categories:

 1. Click on the magnifying glass to open the search bar for all fields
 2. Type your search term(s) in the box below the column header
 3. Hit Enter to filter the results

`*` is the operator for 'includes'. For example, enter `*SSL` in the `Short description` field to find all tickets with descriptions that include `SSL` in the title.

You can also sort columns. For example, sort by `Opened` to see the most recent tickets in your search. Click on the "hamburger" to the left of a column name to access sorting options for that field.

Here is a sample URL for a filtered and sorted view: https://princeton.service-now.com/nav_to.do?uri=%2Fsc_req_item_list.do%3Fsysparm_query%3Dshort_descriptionLIKESSL%26sysparm_first_row%3D1%26sysparm_view%3D%26sysparm_choice_query_raw%3D%26sysparm_list_header_search%3Dtrue
