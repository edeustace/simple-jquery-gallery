### introduction
A simple jquery gallery plugin, it displays an image and then some thumbs underneath.

### usage
    <div id="gallery">
       <div id="thumbs">
          <div class="thumbHolder">
              <a href="${main_image}">
                <img src="${thumb_image}"/>
              </a>
          </div>
          [
          <div class="thumbHolder">
          ...]
       </div>
    </div>

see the example


### build
install [coffeescript](http://jashkenas.github.com/coffee-script/)

    coffee --watch --output lib/ src/
    