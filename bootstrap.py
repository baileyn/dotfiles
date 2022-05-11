import gzip
import json
import os
import platform
import subprocess
import sys
import urllib.request

from pathlib import Path

# The binary directory to store binaries.
SYSTEM = platform.system()

if SYSTEM == 'Windows':
    BINARY_DIR = Path.home().joinpath("bin")
else:
    raise Exception(f'Unsupported Operating System: {SYSTEM}')

def go_install(path: str, version: str):
    subprocess.run(['go', 'install', f'{path}@{version}'], shell=True)

def get_latest_github_release(repo: str, name: str):
    url = f'https://api.github.com/repos/{repo}/releases/latest'
    req = urllib.request.Request(url)

    r = urllib.request.urlopen(req).read()
    data = json.loads(r.decode('UTF-8'))

    for asset in data['assets']:
        if name in asset['name']:
            return asset['browser_download_url']

    return None

def download_latest_github_release(repo: str, name: str, output: str):
    url = get_latest_github_release(repo, name)
    if not url:
        raise Exception(f'Unable to download {name} from {repo}')

    urllib.request.urlretrieve(url, output)

def ungzip(name: str, output: str):
    with gzip.open(name, 'rb') as f:
        with open(output, 'wb') as out_file:
            out_file.write(f.read())

def check_bin_on_path():
    path = os.getenv('PATH')
    if not path:
        return False

    parts = path.split(os.pathsep)
    for part in parts:
        if part == str(BINARY_DIR):
            return True

    return False

def npm_install(program: str):
    subprocess.run(['npm', 'install', '-g', program], shell=True)

if __name__ == '__main__':
    print(f'Using Binary Directory: {BINARY_DIR}')

    print(f'Checking {BINARY_DIR} is on PATH...', end='')
    if check_bin_on_path():
        print('Success')
    else:
        print('Error')
        sys.exit(1)

    go_install('golang.org/x/tools/gopls', 'latest')

    # Download latest rust-analyzer
    # TODO: Handle different architectures.
    download_latest_github_release('rust-analyzer/rust-analyzer', 'x86_64-pc-windows-msvc', 'rust-analyzer.gz')
    ungzip('rust-analyzer.gz', f'{BINARY_DIR}/rust-analyzer.exe')
    os.remove('rust-analyzer.gz')
        
    # npm_install('pyright')

