import subprocess

def npm_install(program: str):
    subprocess.run(['npm', 'install', '-g', program], shell=True)

if __name__ == '__main__':
    npm_install('pyright')

