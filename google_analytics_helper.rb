module GoogleAnalyticsHelper
  
  
  # Google Analytics Helper
  # =======================
  
  # Source: [GitHub](https://github.com/sklppr/google_analytics_helper)  
  # Author: [@sklppr](https://twitter.com/sklppr)
  
  
  # Basic Functionality
  # -------------------
  
  # Accessor for Google Analytics Queue (GAQ).
  attr_accessor :gaq
  
  
  # Initialize GAQ when instantiated.
  def initialize(*args)
    super(*args)
    @gaq ||= []
  end
  
  
  # Render Google Analytics snippet.
  def ga_snippet
    current_gaq = gaq.clone # Copy current GAQ and ...
    gaq.clear # ... clear actual GAQ to avoid commands being preserved in case ...
    return unless config_id || config_defaults # ... GA is not configured and the snippet is not rendered.
    commands = (default_gaq + current_gaq).reduce { |str, cmd| "#{str},#{cmd}" }
    file = (Rails.env == "development" || config_debug) ? "u/ga_debug.js" : "ga.js"
    content_tag(:script, "var _gaq=[#{commands}];(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.async=true;g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/#{file}';s.parentNode.insertBefore(g,s)}(document,'script'));".html_safe)
  end
  
  
  # Configuration
  # -------------
  
  # Default GAQ.
  def default_gaq
    config_defaults || [["_setAccount", config_id], ["_trackPageview"]]
  end
  
  
  # Google Analytics ID from config.
  def config_id
    Rails.application.config.respond_to?(:google_analytics_id) ? Rails.application.config.google_analytics_id : false
  end
  
  
  # Default commands from config.
  def config_defaults
    Rails.application.config.respond_to?(:google_analytics_defaults) ? Rails.application.config.google_analytics_defaults : false
  end
  
  
  # Debug setting from config.
  def config_debug
    Rails.application.config.respond_to?(:google_analytics_debug) ? Rails.application.config.google_analytics_debug : false
  end
  
  
  # Preserving Commands
  # --------------------
  
  # Preserve pending commands.
  def gaq_preserve
    unless gaq.empty?
      flash[:gaq] = gaq
    end
  end
  
  
  # Restore GAQ from flash.
  def gaq_restore
    if flash[:gaq]
      gaq.concat(flash[:gaq])
      flash.delete(:gaq)
    end
  end
  
  
  # Google Analytics Tracking Code
  # ------------------------------
  
  # [API Docs](http://code.google.com/apis/analytics/docs/gaJS/gaJSApi.html)
  
  # ### Handling optional arguments
  
  # Singleton to ouput `undefinded` instead of `"undefined"`.
  class Undefined
    include Singleton
    def to_s; "undefined" end
    alias :to_str :to_s
  end
  
  
  # Merge mandatory and optional params into one array, replacing `nil` with `undefined`.
  # Usage: `with_opt([param, param, param], opt_param, opt_param)`
  def with_opt(array, *args)
    args.each { |arg| array.push (arg.nil? ? Undefined.instance : arg) }
    array
  end
  
  
  # ### [Basic Configuration](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiBasicConfiguration.html)
  
  def _deleteCustomVar(index)
    gaq.push ["_deleteCustomVar", index]
  end
  
  def _getName
    gaq.push ["_getName"]
  end
  
  def _getAccount
    gaq.push ["_getAccount"]
  end
  
  def _getVersion
    gaq.push ["_getVersion"]
  end
  
  def _getVisitorCustomVar(index)
    gaq.push ["_getVisitorCustomVar", index]
  end
  
  def _setAccount(accountID)
    gaq.push ["_setAccount", accountID]
  end
  
  def _setCustomVar(index, name, value, opt_scope=nil)
    gaq.push with_opt(["_setCustomVar", index, name, value], opt_scope)
  end
  
  def _setSampleRate(newRate)
    gaq.push ["_setSampleRate", newRate]
  end
  
  def _setSessionCookieTimeout(cookieTimeoutMillis)
    gaq.push ["_setSessionCookieTimeout", cookieTimeoutMillis]
  end
  
  def _setSiteSpeedSampleRate(sampleRate)
    gaq.push ["_setSiteSpeedSampleRate", sampleRate]
  end
  
  def _setVisitorCookieTimeout(cookieTimeoutMillis)
    gaq.push ["_setVisitorCookieTimeout", cookieTimeoutMillis]
  end
  
  def _trackPageview(opt_pageURL=nil)
    gaq.push with_opt(["_trackPageview"], opt_pageURL)
  end
  
  
  # ### [Campaign Tracking](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiCampaignTracking.html)
   
  def _setAllowAnchor(bool)
    gaq.push ["_setAllowAnchor", bool]
  end
  
  def _setCampContentKey(newCampContentKey)
    gaq.push ["_setCampContentKey", newCampContentKey]
  end
  
  def _setCampMediumKey(newCampMedKey)
    gaq.push ["_setCampMediumKey", newCampMedKey]
  end
  
  def _setCampNameKey(newCampNameKey)
    gaq.push ["_setCampNameKey", newCampNameKey]
  end
  
  def _setCampNOKey(newCampNOKey)
    gaq.push ["_setCampNOKey", newCampNOKey]
  end
  
  def _setCampSourceKey(newCampSrcKey)
    gaq.push ["_setCampSourceKey", newCampSrcKey]
  end
  
  def _setCampTermKey(newCampTermKey)
    gaq.push ["_setCampTermKey", newCampTermKey]
  end
  
  def _setCampaignTrack(bool)
    gaq.push ["_setCampaignTrack", bool]
  end
  
  def _setCampaignCookieTimeout(cookieTimeoutMillis)
    gaq.push ["_setCampaignCookieTimeout", cookieTimeoutMillis]
  end
  
  def _setReferrerOverride(newReferrerUrl)
    gaq.push ["_setReferrerOverride", newReferrerUrl]
  end
  
  
  # ### [Domains & Directories](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiDomainDirectory.html)
  
  def _cookiePathCopy(newPath)
    gaq.push ["_cookiePathCopy", newPath]
  end
  
  def _getLinkerUrl(targetUrl, useHash)
    gaq.push ["_getLinkerUrl", targetUrl, useHash]
  end
  
  def _link(targetUrl, useHash)
    gaq.push ["_link", targetUrl, useHash]
  end
  
  def _linkByPost(formObject, useHash)
    gaq.push ["_linkByPost", formObject, useHash]
  end
  
  def _setAllowLinker(bool)
    gaq.push ["_setAllowLinker", bool]
  end
  
  def _setCookiePath(newCookiePath)
    gaq.push ["_setCookiePath", newCookiePath]
  end
  
  def _setDomainName(newDomainName)
    gaq.push ["_setDomainName", newDomainName]
  end
  
  
  # ### [E-Commerce](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiEcommerce.html)
  
  def _addItem(orderId, sku, name, category, price, quantity)
    gaq.push ["_addItem", orderId, sku, name, category, price, quantity]
  end
  
  def _addTrans(orderId, affiliation, total, tax, shipping, city, state, country)
    gaq.push ["_addTrans", orderId, affiliation, total, tax, shipping, city, state, country]
  end
  
  def _trackTrans
    gaq.push ["_trackTrans"]
  end
  
  
  # ### [Event Tracking](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiEventTracking.html)
  
  def _trackEvent(category, action, opt_label=nil, opt_value=nil)
    gaq.push with_opt(["_trackEvent", category, action], opt_label, opt_value)
  end
  
  
  # ### [Search Engines and Referrers](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiSearchEngines.html)
  
  def _addIgnoredOrganic(newIgnoredOrganicKeyword)
    gaq.push ["_addIgnoredOrganic", newIgnoredOrganicKeyword]
  end
  
  def _addIgnoredRef(newIgnoredReferrer)
    gaq.push ["_addIgnoredRef", newIgnoredReferrer]
  end
  
  def _addOrganic(newOrganicEngine, newOrganicKeyword, opt_prepend=nil)
    gaq.push with_opt(["_addOrganic", newOrganicEngine, newOrganicKeyword], opt_prepend)
  end
  
  def _clearIgnoredOrganic
    gaq.push ["_clearIgnoredOrganic"]
  end
  
  def _clearIgnoredRef
    gaq.push ["_clearIgnoredRef"]
  end
  
  def _clearOrganic
    gaq.push ["_clearOrganic"]
  end
  
  
  # ### [Social Interactions](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiSocialTracking.html)
  
  def _trackSocial(network, socialAction, opt_target=nil, opt_pagePath=nil)
    gaq.push with_opt(["_trackSocial", network, socialAction], opt_target, opt_pagePath)
  end
  
  
  # ### [Web Client](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiWebClient.html)
  
  def _getClientInfo
    gaq.push ["_getClientInfo"]
  end
  
  def _getDetectFlash
    gaq.push ["_getDetectFlash"]
  end
  
  def _getDetectTitle
    gaq.push ["_getDetectTitle"]
  end
  
  def _setClientInfo(bool)
    gaq.push ["_setClientInfo", bool]
  end
  
  def _setDetectFlash(bool)
    gaq.push ["_setDetectFlash", bool]
  end
  
  def _setDetectTitle(bool)
    gaq.push ["_setDetectTitle", bool]
  end
  
  
  # ### [Urchin Server](http://code.google.com/apis/analytics/docs/gaJS/gaJSApiUrchin.html)
  
  def _getLocalGifPath
    gaq.push ["_getLocalGifPath"]
  end
  
  def _getServiceMode
    gaq.push ["_getServiceMode"]
  end
  
  def _setLocalGifPath(newLocalGifPath)
    gaq.push ["_setLocalGifPath", newLocalGifPath]
  end
  
  def _setLocalRemoteServerMode
    gaq.push ["_setLocalRemoteServerMode"]
  end
  
  def _setLocalServerMode
    gaq.push ["_setLocalServerMode"]
  end
  
  def _setRemoteServerMode
    gaq.push ["_setRemoteServerMode"]
  end
  
  
end
