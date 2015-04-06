# pipedrive_last
the third and last pipedrive integration app

Installing

    bundle
    rake db:migrate
    rails server
    
Setup/Workflow
    
    The App Key isn't necessary when using the app, but the actions won't reflect on Pipedrive without it.
    You can add it as you create a user or later on.
    
    Any user can integrate with any Pipedrive account. Though only one at a time. To disconnect just wipe the app_key
    field or try to integrate with an invalid App Key.
    
    Whenever you successfully integrate with any Pipedrive account the app will query the account for the list of 
    customized fields (currently "Job Title" and "Website"). If any of them is missing they will be added.
    
    Currently only CREATE is supported therefore whenever you add a new Lead (while integrated), the creation 
    will also take place at Pipedrive. The lead's organization will be searched for and used if found. 
    Otherwise a new one will be added.
