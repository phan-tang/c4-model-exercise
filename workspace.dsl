workspace {

    model {
        #---Level 1
        #---People/actor
        ## <variable> = person <name> <description> <tag>
        publicUser = person "Public User" "Any user who can access but is not logged on to a portal" "User"
        authorizedUser = person "Authorized User" "A user of book store system, who has a personal account" "User"

        #---Software system
        ## <variable> = softwareSystem <name> <description> <tag>
        bookstoreSystem = softwareSystem "Books Store System" "Allows users to interact with books records" "Target System" {
            ##---Level 2
            adminWebApi = container "Admin Web API" "Allows only authorized users administering books details via HTTP handlers" "Go" {
                ###---Level 3
                bookService = component "Book Service" "Allows administering books detail" "Go Service"
                authorizationService = component "Authorization Service" "Allows authorizing users, books detail" "Go Service"
                eventsPublisherService = component "Events Publisher Service" "Publishes books-related domain events"  "Go Service"

            }
            searchWebApi = container "Search Web API" "Allows only authorized users searching books records via HTTPs handlers" "Go"
            publicWebApi = container "Public Web API" "Allows public users getting books details" "Go"
            bookKafkaSystem = container "Book Kafka System" "Handles book-related domain events" "Apache Kafka 3.0"
            elasticSearchEventsConsumer = container "ElasticSearch Events Consumer" "Listening to Kafka domain events and write publisher to Search Database for updating" "Go"
            searchDatabase = container "Search Database" "Stores searchable books details" "ElasticSearch" "Database"
            readWriteRelationalDatabase = container "Read/Write Relational Database" "Stores books details" "PostgreSQL" "Database"
            readerCache = container "Reader Cache" "Caches books details" "Memcached" "Database"
            publisherRecurrentUpdater = container "Publisher Recurrent Updater" "Updates the Read/Write Relational Database with detail from Publisher System" "Kafka"
        }

        #---External system
        ## <variable> = softwareSystem <name> <description> <tag>
        authorizationSystem = softwareSystem "Authorization System" "An external system used for authorization" "External System"
        publisherSystem = softwareSystem "Publisher System" "An external system used for giving details about books published by Books Store System" "External System"


        #---Relationship between people and software system
        authorizedUser -> bookstoreSystem "Interacts with book records using"
        publicUser -> bookstoreSystem "Interacts with book records using"

        bookstoreSystem -> authorizationSystem "Authorizes user using"
        bookstoreSystem -> publisherSystem "Gives details about published books using"

        authorizationSystem -> authorizedUser "Authorizes user"
        publisherSystem -> authorizedUser "Gives details about published books to"
        publisherSystem -> publicUser "Gives details about published books to"

        #---Relationship between containers
        publicUser -> publicWebApi "Gets books details using"
        publicWebApi -> readWriteRelationalDatabase "Reads data from"
        publicWebApi -> readerCache "Reads/writes data to"

        authorizedUser -> searchWebApi "Searches books records via HTTPs handlers"
        searchWebApi -> authorizationSystem "Authorizes users using"
        searchWebApi -> searchDatabase "Search read-only records using"

        authorizedUser -> adminWebApi "Administers books details via HTTP handlers"
        adminWebApi -> authorizationSystem "Authorizes users using"
        adminWebApi -> readWriteRelationalDatabase "Administers records using" "Reads data from and writes data to"
        adminWebApi -> bookKafkaSystem "Publishes events to"

        elasticSearchEventsConsumer -> bookKafkaSystem "Listens to Kafka domain events using"
        elasticSearchEventsConsumer -> searchDatabase "Write publisher to"

        publisherRecurrentUpdater -> publisherSystem "Listens to external events coming from"
        publisherRecurrentUpdater -> adminWebApi "Updates data with detail from Publisher System using"

        #---Relationship between components
        authorizedUser -> bookService "Administers books detail using"
        bookService -> readWriteRelationalDatabase "Read from and write data to"
        bookService -> eventsPublisherService " Publishes books-related events to"
        bookService -> authorizationService "Authorizes books detail using"

        authorizationService -> authorizationSystem "Authorizes users using"
        eventsPublisherService -> bookKafkaSystem "Publishes books-related domain events to" 
    }

    views {
        #---Level 1
        systemContext bookstoreSystem "SystemContext" {
            include *
            autoLayout
        }

        #---Level 2
        container bookstoreSystem "Containers" {
            include *
            # autoLayout 
        }

        component adminWebApi "Components"{
            include *
            autoLayout
        }

        styles {
            # element <tag> {}

            element "External System" {
                background #999999
                color #ffffff
            }

            element "Database" {
                shape Cylinder
            }
        }

        theme default
    }

}