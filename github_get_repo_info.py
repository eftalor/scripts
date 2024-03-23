import requests

ghapi = "xyz"

owner = input("Enter you Github username:")
repo = input("Enter the repository URL :")

url = f"https://api.github.com/repos/{owner}/{repo}"
print(f"url:{url}")

headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "Bearer " + ghapi, 
    "X-GitHub-Api-Version": "2022-11-28"
}

res = requests.get(url, headers=headers)
print(f"Status code: {res.status_code}")
json_res = res.json()
print("Name: {0}".format(json_res['name']))
print("Description: {0}".format(json_res['description']))
print("Forks Count: {0}".format(json_res['forks_count']))
print("Language: {0}".format(json_res['language']))
