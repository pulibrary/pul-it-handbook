**Octokit**

[Octokit](https://developer.github.com/v3/libraries/) is a handy GitHub API client library. It offers a [Ruby toolkit](https://github.com/octokit/octokit.rb). 

**Github Authentication**

To authenticate, the use of a personal access token or an oauth token is recommended over basic username/password authentication. 
See the GitHub Developer Guide [here](https://developer.github.com/v3/#authentication).

The token must be scoped appropriately; documentation can be found [here](https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/). A client's scopes can be viewed using `client.scopes`.

**Of Note**

* When interacting with a private repository, the token must be scoped to "repo".
* Requests requiring authentication can sometimes throw a--somewhat misleading--`404-Not Found`.

**Example: Create github issues from a csv file**

```
require 'octokit'
require 'faraday'
require 'csv'
require_relative 'secrets.rb'

#establish connection
client = Octokit::Client.new({:baseUrl => @base_url, :access_token => @access_token})

#parse CSV
csv = CSV.parse(File.read(@input_file), :headers => true)

#use column names from CSV
csv.each do |row|
	client.create_issue(@repo, row['title'], row['description'], options = {
		:assignee => row['assignee'],
		:labels => [row['label1']]})
	puts "Imported issue: #{row['title']}"
end
```
