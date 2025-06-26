import boto3
from botocore.exceptions import ClientError

def get_vars_from_ssm(ssm_params: dict):
    """Get backend setup parameters from SSM parameter store.
    Needs the necessary information to make SSM calls.

    :param ssm_params: dict containing as key the var name as used in the env
        and as value a tuple with SSM parameter store name and whether or not to decrypt it
        from SecureString.
        Example: {'USERNAME': ('username', False), 'PASSWORD': ('password', True)}
    """
    creds = {}
    session = boto3.session.Session()
    ssm = session.client("ssm", region_name="eu-central-1")
    for env_var_name in ssm_params:
        value = None
        decrypt = ssm_params[env_var_name][1]
        ssm_param = ssm_params[env_var_name][0]
        try:
            response = ssm.get_parameter(
                Name=f'/dev/webstore/{ssm_param}',
                WithDecryption=decrypt)
            value = response["Parameter"]["Value"]
        except ClientError as e:
            print(e)
        finally:
            creds[env_var_name] = value

    all_creds_provided = all(v is not None for v in creds.values())
    return creds, all_creds_provided