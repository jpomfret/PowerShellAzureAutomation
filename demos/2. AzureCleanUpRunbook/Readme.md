1. Terraform to create resources
   - Look at the portal
   - run the runbook
   - Get permissions error – but it didn’t fail the runbook
  
2. Azure Automation extension in VSCode
    - Open published runbook locally

3. Add try\catch and errorAction preference (script 2)
    - Now it’s failing the runbook, and stopping when it hits the first error
    - Let’s fix the error

4. We added a managed identity
    - Need to give it permissions
    - Go to identity page for Azure Automation
    - Azure Role assignments
        - Give reader to subscription – explain that permissions should be minimal – but for this task we’re looking for all kinds of things across the sub

5. Rerun – works
    - Add schedule
    - Done…. But would be cool to do something with the output

6. ADO
    - Work items – Boards - https://dev.azure.com/jpomfret7/ProjectPomfret/_workitems/recentlyupdated/
    - Add Managed identity to users & assign permissions to create WI
      - https://dev.azure.com/jpomfret7/_settings/users
    - Add code to rest api call to create WI (script 3)
        - Basic info …. But ADO descriptions can be HTML (md coming soon!)

7. Format body (HTML)
    - Add a bunch of css and html to make it pretty (script 4)

8.  Makes the code pretty long and messy – move CSS to a shared variable and pull that in (script 5)

TODO – move some of the logic into a shared function too?

