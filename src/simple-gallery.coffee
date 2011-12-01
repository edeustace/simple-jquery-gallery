###
A simple jQuery plugin that shows images in a gallery format.
###
jQuery.fn.simpleGallery = (options)->
  
  defaultConfig = 
    uid: Math.floor( Math.random() * 1000)
    fadeTime: 700
    easeIn : 'easeInSine'
    easeOut : 'easeInSine'
    activeAlpha : 1
    nonActiveAlpha : 0.6
    mouseOverAlpha: 0.8

  if options?
    config = $.extend defaultConfig, options
  else
    config = defaultConfig

  ###
  vars
  ###
  imageLoadInProgress = false
  loadedImages = {}
  activeImageUrl = ""
  imageLinks = this.find 'a'
  loadFirstImage = true


  ###
  methods
  ###
  loadImage = (url) ->
    if imageLoadInProgress 
      return

    imageLoadInProgress = true

    $("#image-viewer").attr 'class', 'loading'

    img = new Image()

    $(img)
    .load ->
      loadedImages[url] = "loaded"
      $(".loadingInfoItem").fadeOut 'fast', -> 
        $(this).remove() 
      swapImages this
    
    .error ->
      throw "Error loading image"

    .attr 'src', url

  swapImages = (newImage)->
    $("#image-viewer").removeClass 'loading'

    if $("#image-viewer").find('img').length > 0
      $("#image-viewer").find('img').fadeOut config.fadeTime, ->
        $(this).remove()
        addNewImageAndFadeIn newImage
    else
      addNewImageAndFadeIn newImage
    null

  addNewImageAndFadeIn = (newImage) ->
    $(newImage).hide()
    $("#image-viewer").append newImage
    $(newImage).fadeIn config.fadeTime, ->
      imageLoadInProgress = false
    null

  onThumbnailClick = ->
    imageUrl = $(this).attr 'name'

    if imageUrl == activeImageUrl
      return

    activeImageUrl = imageUrl

    if loadedImages[imageUrl]?
      newImage = new Image()
      newImage.src = imageUrl
      swapImages newImage
    else
      showLoadingInThumb this
      loadImage imageUrl

    updateThumbs()
    null

  showLoadingInThumb = (element) ->
    $(element).parent().append '<div class="loadingInfoItem"></div>'
    null

  updateThumbs = ->
    $("#thumbs a").each ->
      thumbUrl = $(this).attr 'name'
      alpha = if thumbUrl == activeImageUrl then config.activeAlpha else config.nonActiveAlpha
      $(this).stop().fadeTo 'fast', alpha
    null

  onMouseOver = ->
    if $(this).attr('name') == activeImageUrl
      return
    $(this).stop().fadeTo 'fast', config.activeAlpha
    null

  onMouseOut = ->
    if $(this).attr('name') == activeImageUrl
      return
    $(this).stop().fadeTo 'fast', config.nonActiveAlpha
    null

  imageLinks.each ->
    url = $(this).attr 'href'
    $(this).attr 'href', 'javascript:void(0)'
    $(this).attr 'name', url
    $(this).click onThumbnailClick
    $(this).mouseover onMouseOver
    $(this).mouseout onMouseOut

    if loadFirstImage
      loadFirstImage = false
      onThumbnailClick.apply this
    null

