# tc

CSS for clean and fast web apps

---

## Usage

* [Download tc](https://github.com/tc/tc/archive/0.7.5.zip)

* Open index.html to view the usage guides.
* Copy your desired theme CSS from the `css/` folder into your project
* Copy the `img/` and `font/` folders into your project ( Feel free to only
  copy the images and font weights you intend to use )
* Link the CSS into your page

```css
<link rel="stylesheet" type="text/css" href="css/tc-mobile-light.min.css">
```

_*Alternatively incorporate the css into your build process if you are so
inclined._

---

## Contributing

Start by checking out our [Backlog](http://huboard.com/tc/tc/backlog). (Pls file issues against this repo.)

* [Fill out the CLA here](http://tc.io/dev/tc-cla.html)
* [fork](https://help.github.com/articles/fork-a-repo) the repo
* Create a branch

        git checkout -b my_branch

* Add your changes following the [coding guidelines](https://github.com/tc/tc/wiki/Coding-Guidelines)
* Commit your changes

        git commit -am "Added some awesome stuff"

* Push your branch

        git push origin my_branch

* make a [pull request](https://help.github.com/articles/using-pull-requests)

For the details see our [Engineering Practices](https://github.com/tc/tc/wiki/Engineering-Practices).

### Testing

For performance tests, see [dev/test/perf/telemetry/](https://github.com/tc/tc/tree/master/dev/test/perf/telemetry).

### Building

tc uses [Grunt](http://gruntjs.com/) to build

* Open the terminal from the tc directory

        cd tc

* Install [npm](http://nodejs.org/download/)
_*comes packaged with node._
* Install its command line interface (CLI) globally

        npm install -g grunt-cli

* Install dependencies with npm

        npm install


_*tc uses Grunt 0.4.0. You might want to [read](http://gruntjs.com/getting-started) more on their website if you haven't upgraded since a lot has changed._

* Type `grunt` in the command line to build the css.
* The results will be built into the release folder.
* Alternatively type `grunt watch` to have the build run automatically when you make changes to
source files.

---

## Release notes
See [Release Notes](https://github.com/tc/tc/releases/).

---

## License

[Apache license](https://raw.github.com/tc/tc/master/LICENSE)

