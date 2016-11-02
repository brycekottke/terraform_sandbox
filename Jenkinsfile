#!groovy

// groovy parameters
jenkins_node = 'master'

// build parameters
properties([ parameters([

  choice( name: 'mode',
       choices: 'Create\nDestroy',
       description: 'Job mode: Create | Destroy' ),

  string( name: 'aws_region',
       defaultValue: 'us-east-1',
       description: 'AWS Deployment Region' ),

  string( name: 'aws_access_key',
       defaultValue: 'ABC123UMEDOREIME',
       description: 'AWS Access Key' ),

  string( name: 'aws_secret_key',
       defaultValue: 'SSHHSECRET',
       description: 'AWS Secret Key' ),

  string( name: 'working_directory',
       defaultValue : '.',
       description  : 'Path to this file' ),

  string( name: 'bucket_name',
       defaultValue: '2w-gbruno',
       description: 'Location of S3 bucket to place tfstate files' ),

  string( name: 'state_name',
       defaultValue: 'aws_infra.tfstate',
       description: 'tfstate name' ),

  string( name: 'variables_path',
       defaultValue: 'variables.tf',
       description: 'Where is the tfvars/variables.tf file located?' ),

  string( name: 'environment_name',
       defaultValue: 'test',
       description: 'Environment Name' ),

]), pipelineTriggers([]) ])


try {
  err = null
  currentBuild.result = "SUCCESS"

  // Env Vars for jenkins_node
  env.tf_cmd = "/var/jenkins_home/tools/org.jenkinsci.plugins.terraform.TerraformInstallation/Terraform/terraform "
  env.working_directory = working_directory
  env.bucket_name = bucket_name
  env.state_name = state_name
  env.environment_name = environment_name
  env.variables_path = variables_path
  env.aws_region = aws_region
  env.aws_access_key = aws_access_key
  env.aws_secret_key = aws_secret_key

  switch (mode) {

    // Begin Pipeline Creation
    case "Create":

      node(jenkins_node) {
        stage ('Checkout') {
          checkout scm
        }
        //Begin Remote State Check/Bucket Creation
        stage ('Remote State Check') {
          echo "Checking s3 bucket, ${bucket_name}..."
          dir(working_directory) {
            sh '''
              set +e
              resp=$( aws s3api head-bucket --bucket $bucket_name 2>&1 )
              if [ $? -eq 0 ]; then
                echo "$bucket_name already exists!"
              else
                set -e
                if [[ "$resp" == *"404"* ]]; then
                  echo "Creating $bucket_name S3 bucket!"
                  aws s3 mb s3://$bucket_name
                  aws s3api put-bucket-versioning --bucket $bucket_name \
                    --versioning-configuration Status=Enabled
                  key=$(echo $state_name | cut -d/ -f1)
                  aws s3api put-object --bucket $bucket_name --key $key/
                fi
                if [[ "$resp" == *"403"* ]]; then
                  echo "Received 403 error, please verify your IAM keys have proper S3 access!"
                fi
              fi
            '''
          }
        } // end Remote State Check

        stage ('TF Plan Create') {
          dir(working_directory) {
            sh '''
              $tf_cmd version
              rm -vf ./*.tfstate ./.terraform/*.tfstate
              $tf_cmd get -update -no-color
              $tf_cmd remote config -no-color -backend=s3 \
                -backend-config="bucket=$bucket_name" \
                -backend-config="key=$state_name" \
                -backend-config="encrypt=true" \
                -backend-config="region=$aws_region"

              $tf_cmd plan -no-color \
                -var-file=$variables_path \
                -out=create.tfplan
            '''
          } // dir
        } // end TF Plan Create
      } // end node

      // keeps Jenkins Job paused, but Executor available while waiting for Approval
      input 'Deploy stack?'

      node(jenkins_node) {
        stage ('TF Deploy') {
          dir(working_directory) {
            sh '''
              $tf_cmd show
              $tf_cmd apply -no-color create.tfplan
              $tf_cmd remote config -disable -no-color
            '''
          } // dir
        } // end TF Deploy

        stage ('Post Run Tests') {
          echo "Run tests?"
        } // end Post Run Tests
      } // end node
      echo "Creaton of the pipeline complete."

    break // end - create

  // pipeline - destroy
    case "Destroy":

      node(jenkins_node) {
        stage ('TF Plan Destroy') {
          dir(working_directory) {
            sh '''
              rm -vf ./*.tfstate ./.terraform/*.tfstate
              $tf_cmd remote config -no-color -backend=s3 \
                -backend-config="bucket=$bucket_name" \
                -backend-config="key=$state_name" \
                -backend-config="encrypt=true" \
                -backend-config="region=$aws_region"

              $tf_cmd plan -destroy -no-color \
                -var-file=$variables_path \
                -out=destroy.tfplan
            '''
          } // dir
        } // end TF Plan Destroy
      } // end node

      // keeps Jenkins Job paused, but Executor available while waiting for Approval
      input 'Really destroy stack?'

      node(jenkins_node) {
        stage ('TF Destroy') {
          dir(working_directory) {
            sh '''
              $tf_cmd apply -no-color destroy.tfplan
              $tf_cmd remote config -disable -no-color
              rm -vf ./*.tfstate ./.terraform/*.tfstate
            '''
          } // dir
        } // end TF Destroy
      } // end node
      echo "Destruction completed."

    break // end - destroy

    default:
      error "Invalid 'mode' specified - use either 'create' or 'destroy'"

  } // end switch

} catch (caughtError) {
  err = caughtError
  currentBuild.result = "FAILURE"
} finally {
  /* Must re-throw exception to propagate error */
  if (err) {
    throw err
  }
}
