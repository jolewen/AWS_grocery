import boto3
from botocore.exceptions import ClientError

def get_vars_from_ssm(ssm_params: dict):
    """Get backend setup parameters from SSM parameter store."""
    creds = {}
    session = boto3.session.Session()
    ssm = session.client("ssm", region_name="eu-central-1")
    for param_name in ssm_params:
        decrypt = False
        value = None
        if isinstance(ssm_params[param_name], tuple):
            decrypt = True
        try:
            response = ssm.get_parameter(
                Name=f'/dev/webstore/{ssm_params[param_name]}',
                WithDecryption=decrypt)
            value = response["Parameter"]["Value"]
        except ClientError as e:
            print(e)
        finally:
            creds[param_name] = value

    all_creds_provided = all(v is not None for v in creds.values())
    return creds, all_creds_provided