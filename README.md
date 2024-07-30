# Daily archiving scipt with workflow
Script archives files that are older than 30 days and moves them to an AWS S3 bucket. The workflow runs the script once every day at 00:00 UTC.
## Sript
The script calculates the age of the files based on the name of their comprising subfolder, whose names include the time of thier creation.
### Configuration:
* Sets the  base, remote and a temporary archive directory
* Stores the current time and the critical age of the files (30 days).
### Find old files:
* From the base folder, the script finds the subfolders whose name includes their creation time and loops over them.
* In every cycle the script reads the name of the subfolder and checks if it is older than 30 days.
* If a subfolder is older than 30 days, the script creates a .zip file and moves the current subfolder into it with its contents.
### Move old files to bucket:
* After zipping the subfolder, the .zip file is moved to the AWS S3 bucket.
* If the operation was successful, the .zip file is deleted.
* Else it displays an error message that the directory could not be moved to the bucket.
### Cleanup:
* After the loop the temporary directory is deleted with its contents.
## Workflow
Runs on ubuntu-latest.
### Schedule:
* Schedules the run to 00:00 UTC every day. For testing the workflow can be triggered manually.
### Set up AWS CLI:
* Installs AWS CLI
### Configure AWS credentials:
* Configures AWS Access Key ID, AWS Secret Access Key and default region.
### Run archiving script:
* Sets up environment with the neccessary AWS secrets
* and the source and remote directories
* then runs the script.
## Prerequisites
* AWS account with access to create and manage S3 buckets
* AWS CLI configured with appropriate credentials
* GitHub account
