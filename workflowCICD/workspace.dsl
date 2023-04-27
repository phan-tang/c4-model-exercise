workspace extends ../cloud/workspace.dsl {

    model {
        developer = person "Developer" "A software engineer who contributes the system" "User"
        dynamicBooksStoreSystem = softwareSystem "Workflow CI/CD for deploying Books Store System" "Workflow CI/CD for deploying Books Store System" {
            sourceRepository = container "Source Code Repository" "A storage location for code and other software development assets, such as documentation, tests, and scripts" "GiHub, GitLab, Bitbucket, ..."
            awsCloud = container "AWS Cloud" {
                tags "AWS" "Amazon Web Services - Cloud"
                #---Dynamic diagram
                codePipeline = component "AWS CodePipeline" "Downloads source code and starts the build process" "AWS CodePipeline Service" {
                    tags "AWS" "Amazon Web Services - CodePipeline"
                }
                codeBuild = component "AWS CodeBuild" "Downloads the necessary source files, builds and tags a local Docker container image" "AWS CodeBuild Service" {
                    tags "AWS" "Amazon Web Services - CodeBuild"
                }
                amazonEKS = component "AWS EKS" "Amazon Web Services - Elastic Kubernetes Service" "AWS EKS Service" {
                    tags "AWS" "Amazon Web Services - Elastic Kubernetes Service"
                }
                amazonECR = component "Amazon ECR" "Stores container images which are tagged with a unique label derived from the repository commit hash" "Amazon ECR Service" {
                    tags "AWS" "Amazon Web Services - EC2 Container Registry"
                }
            }
        }
        developer -> sourceRepository "Commits and pushes code to"
        sourceRepository -> codePipeline "Uses a webhook to trigger"
        codePipeline -> sourceRepository "Downloads to start the build process"
        codeBuild -> codePipeline "Downloads the necessary source files and builds"
        codeBuild -> amazonECR "Pushes container image to"
        codeBuild -> amazonEKS "Deploys image on"
    }

    views {
        dynamic awsCloud "WorkflowCICD" "Workflow CI/CD for deploying Books Store System" {
            developer -> sourceRepository "Commits and pushes code to"
            sourceRepository -> codePipeline "Uses a webhook to trigger"
            codePipeline -> sourceRepository "Downloads to start the build process"
            codeBuild -> codePipeline "Downloads the necessary source files and builds"
            codeBuild -> amazonECR "Pushes container image to"
            codeBuild -> amazonEKS "Deploys image on"
            autoLayout lr
        }

        styles {
            # element <tag> {}

            element "AWS" {
                background #FFFFFF
            }
        }
    }

}