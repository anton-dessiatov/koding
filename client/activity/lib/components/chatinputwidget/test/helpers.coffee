kd             = require 'kd'
React          = require 'kd-react'
ReactDOM       = require 'react-dom'
expect         = require 'expect'
TestUtils      = require 'react-addons-test-utils'
PortalDropbox  = require 'activity/components/dropbox/portaldropbox'

module.exports = helpers =

  renderDropbox: (props, DropboxType) ->

    result  = TestUtils.renderIntoDocument(
      <DropboxType {...props} />
    )
    dropbox = TestUtils.findRenderedComponentWithType result, PortalDropbox


  dropboxItemsTest: (props, DropboxType, testFn) ->

    dropbox = helpers.renderDropbox props, DropboxType
    content = dropbox.getContentElement()
    items   = content.querySelectorAll '.DropboxItem'

    expect(items.length).toEqual props.items.size
    for item, i in items
      testFn item, props.items.get i


  dropboxSelectedItemTest: (props, DropboxType) ->

    dropbox = helpers.renderDropbox props, DropboxType
    content = dropbox.getContentElement()
    items   = content.querySelectorAll '.DropboxItem'

    expect(items[props.selectedIndex].classList.contains 'DropboxItem-selected').toBe yes

  
  dropboxSelectedItemCallbackTest: (props, DropboxType) ->

    props.onItemSelected = kd.noop
    spy = expect.spyOn props, 'onItemSelected'

    dropbox = helpers.renderDropbox props, DropboxType
    content = dropbox.getContentElement()
    items   = content.querySelectorAll '.DropboxItem'

    newSelectedItem = items[props.selectedIndex + 1]
    TestUtils.Simulate.mouseEnter newSelectedItem

    expect(spy).toHaveBeenCalled()
    expect(spy).toHaveBeenCalledWith props.selectedIndex + 1


  dropboxConfirmedItemCallbackTest: (props, DropboxType) ->

    props.onItemConfirmed = kd.noop
    spy = expect.spyOn props, 'onItemConfirmed'

    dropbox = helpers.renderDropbox props, DropboxType
    content = dropbox.getContentElement()
    items   = content.querySelectorAll '.DropboxItem'

    selectedItem = items[props.selectedIndex]
    TestUtils.Simulate.click selectedItem

    expect(spy).toHaveBeenCalled()

