### Setting up your ASpace environment
1. Clone https://github.com/pulibrary/aspace_helpers
2. Navigate into the cloned directory and run `bundle install`
   - if bundler is not installed, run `gem install bundler`
3. Set up user name and pw as environmental variables
   On Mac:
   - `nano ~/.zshrc`
   - at the end of the file, add `export VARIABLE_NAME=VARIABLE_VALUE` (replace with actual variable name and value)
   - save and close
   - `source ~/.zshrc`
   On Windows:
   - go to Start directory
   - type “Environment Variables” into the search bar and select “Edit the system environment variables” from the results
   - in the System Properties window, click on the “Environment Variables” button
   - in the Environment Variables window, click on the “New” button under either the ‘User variables’ or ‘System variables’ section
   - enter VARIABLE_NAME and VARIABLE_VALUE for each variable
   - save and close
5. Test the variable: `echo $VARIABLE_NAME`
6. Test the connection: `bundle exec ruby test_connection.rb`

### Connecting to ASpace
5. In your ruby file, add these two lines at the top:
   ```
   require 'archivesspace/client'
   require_relative 'helper_methods.rb'
   ```
6. Try to get a value out of ASpace, e.g. add to your file:
   ```
   @client = aspace_staging_login
   record = @client.get('locations/23648').parsed
   puts record
   ```
