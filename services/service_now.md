# Service Now tips and tricks

Service Now offers two different views of tickets in its database: "canned" and "bare-bones".

# Using "canned" Service Now views

Service Now offers quite a few "canned" or default views linked to your login that can be helpful. These pages link to formatted views of individual tickets, like [this](https://princeton.service-now.com/service?id=ticket&sys_id=db679830874149107f147487cebb35f7&table=sc_req_item).

Here are some sample "canned" views:

- https://princeton.service-now.com/service?id=tickets
  by default, this view shows active tickets you created
  with a single click, it can show closed tickets you created

- https://princeton.service-now.com/service?id=my_bookmarks
  by default, this view shows bookmarked services
  with a single click, it can show bookmarked forms

However, these views are restrictive. If you are searching for tickets **assigned** to you, or for a ticket someone else created, it's easier to use the "bare-bones" view of Service Now.

## Using "bare-bones" Service Now views and searching

Service Now also offers a "bare-bones" view that allows more flexibility. These pages link to less-formatted views of individual tickets. Here's the same ticket we looked at above, in its ["bare-bones" form](https://princeton.service-now.com/nav_to.do?uri=%2Fsc_req_item.do%3Fsys_id%3Ddb679830874149107f147487cebb35f7%26sysparm_record_target%3Dsc_req_item%26sysparm_record_row%3D1%26sysparm_record_rows%3D1%26sysparm_record_list%3DnumberCONTAINS335118%255EORDERBYnumber).

You can access the entry point for the "bare-bones" view here:
https://princeton.service-now.com/
The view will be empty.

To search, start with the `Filter navigator` in the upper left corner. If you know what `type` of ticket you are searching for, list all tickets of that type. In our Service Now environment, most tickets opened by OIT are 'Incidents', while tickets opened from Service Now forms are 'Requested items'. There are probably other ticket types. It helps to have an existing ticket as an example - the URL of an example "canned" view can provide helpful clues about the ticket type.

To search for Incidents: type `incident.list` in the Filter navigator and hit Enter, then wait.
To search for Requested items: type `sc_req_item.list` in the Filter navigator and hit Enter, then wait.

Once you have a list of the type of ticket you want, you can filter the results by searching within the various categories. Enter your search terms in the box below the column header. `*` is the operator for 'includes'. For example, enter `*SSL` in the `Short description` field to find all tickets with descriptions that include `SSL` in the title.

You can also sort columns. For example, sort by `Opened` to see the most recent tickets in your search. 

