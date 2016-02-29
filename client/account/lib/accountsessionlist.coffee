$                      = require 'jquery'
kd                     = require 'kd'
kookies                = require 'kookies'
showError              = require 'app/util/showError'
KDListView             = kd.ListView
KDModalView            = kd.ModalView
KDOverlayView          = kd.OverlayView
AccountSessionListItem = require './accountsessionlistitem'


module.exports = class AccountSessionList extends KDListView

  constructor: (options,data) ->
    options = $.extend
      tagName   : "ul"
      itemClass : AccountSessionListItem
    ,options
    super options,data


  deleteItem: (item) ->

    overlay = new KDOverlayView cssClass: 'second-overlay'

    modal = KDModalView.confirm
      title       : 'Remove Session'
      description : 'Do you want to remove ?'
      ok          :
        title     : 'Yes'
        callback  : =>
          session  = item.getData()
          clientId = kookies.get 'clientId'

          session.remove (err) =>
            modal.destroy()
            @emit 'ItemDeleted', item  unless showError err

            # if the deleted session is the current one logout user immediately
            if clientId == session.clientId
              kookies.expire 'clientId'
              global.location.replace '/'

    modal.once   'KDObjectWillBeDestroyed', overlay.bound 'destroy'
    overlay.once 'click',                   modal.bound   'destroy'

    return modal