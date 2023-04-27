workspace extends ../workspace.dsl {

    model {
        #---Microservices deployment
        deploymentEnvironment "Production" {
            deploymentNode "Amazon Web Services EKS" {
                tags "Amazon Web Services - Elastic Kubernetes Service"
                deploymentNode "Amazon Web Services VPC" {
                    tags "Amazon Web Services - VPC"
                    deploymentNode "Public Subnet - pub-net" {
                        tags "Amazon Web Services - VPC subnet public"
                        apiGateway = infrastructureNode "API Gateway" {
                            tags "Amazon Web Services - API Gateway"
                        }
                    }

                    deploymentNode "Private Subnet - priv-net-a" {
                        tags "Amazon Web Services - VPC subnet private"
                        deploymentNode "Amazon EC2 - EC2-a"{
                            tags "Amazon Web Services - EC2 Instance"
                            deploymentNode "Search Web API" {
                                tags "Microservices"
                                searchWebApiInstance = containerInstance searchWebApi
                            }
                            deploymentNode "Public Web API" {
                                tags "Microservices"
                                publicWebApiInstance = containerInstance publicWebApi
                            }
                            deploymentNode "Admin Web API" {
                                tags "Microservices"
                                adminWebApiInstance = containerInstance adminWebApi
                            }
                        }
                    }
                    deploymentNode "Private Subnet - priv-net-b" {
                        tags "Amazon Web Services - VPC subnet private"
                        deploymentNode "Amazon EC2 - EC2-b" {
                            tags "Amazon Web Services - EC2 Instance"
                            deploymentNode "AWS RDS" {
                                tags "Amazon Web Services - RDS PostgreSQL instance"
                                readWriteRelationalDatabaseInstance = containerInstance readWriteRelationalDatabase
                            }
                            deploymentNode "AWS OpenSearch" {
                                tags "Amazon Web Services - Elasticsearch Service"
                                searchDatabaseInstance = containerInstance searchDatabase
                            }
                            deploymentNode "Events Consumer" {
                                tags "Microservices"
                                elasticSearchEventsConsumerInstance = containerInstance elasticSearchEventsConsumer
                            }
                            deploymentNode "AWS ElastiCache" {
                                tags "Amazon Web Services - ElastiCache For Memcached"
                                readerCacheInstance = containerInstance readerCache
                            }
                            deploymentNode "AWS Managed Streaming for Kafka" {
                                tags "Amazon Web Services - Managed Streaming for Kafka"
                                bookKafkaSystemInstance = containerInstance bookKafkaSystem
                            }
                        }
                    }
                }
            }
        }

        # Relationship
        apiGateway -> publicWebApiInstance "Access to"
        apiGateway -> searchWebApiInstance "Access to"
        apiGateway -> adminWebApiInstance "Access to"
    }

    views {
        deployment bookstoreSystem "Production" {
            include *
            autoLayout lr
        }

        theme "https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json"
    }

}