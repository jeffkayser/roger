# Introduction

Roger, after [Jolly Roger](https://en.wikipedia.org/wiki/Jolly\_Roger), is a script to quickly get a simple [Flask](http://flask.pocoo.org/) application skeleton up-and-running, with [jQuery](https://jquery.com/), [Bootstrap](https://getbootstrap.com/), and [Font Awesome](http://fontawesome.io/) installed and ready to use.

I find this setup useful for quick prototyping of my ideas, but building it up manually each time for every such project is time-consuming, repetitive, and annoying. The aim of this script is to automate these boilerplate actions to get to the interesting part quickly.

# Usage

I recommend you put the script in `~/bin` or something of the sort, so that it's accessible from any directory. Then run it from the parent directory where you want to store the newly created app.

```bash
./roger.sh project_name [python_path]
```

- **project_name** - The name of the project of course
- **python_path** - The path to the Python executable to be used in the virtualenv (see below); if omitted the default `python` accessible from `$PATH` is used

# Stack

The script:

- Creates a suitable directory structure for storing a basic Flask webapp
- Creates a [Python virtualenv](https://virtualenv.pypa.io/en/stable/)
- Installs Flask and its dependencies into the virtualenv
- Creates skeleton Flask app with a base [Jina2](http://jinja.pocoo.org/) template that loads the libraries below
- Installs these Bower-managed frameworks:
    - jQuery 1.x
    - Bootstrap 4.x (latest alpha)
    - Font Awesome (latest)
- Initializes a [git repository](https://git-scm.com/) and prepares the initial commit

# Customizing

[`roger.sh`](roger.sh) is a simple [shell script](https://www.gnu.org/software/bash/), so feel free to modify it to fit your needs. It's only been tested on OS X 10.10 ([Yosemite](https://en.wikipedia.org/wiki/OS_X_Yosemite)), so no guarantees are made for it working elsewhere. Fixes or enhancements to the code are always welcome.

# License

MIT. See [LICENSE](LICENSE) for the full text.
