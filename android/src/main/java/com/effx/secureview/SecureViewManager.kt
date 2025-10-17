package com.effx.secureview

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SecureViewManagerDelegate
import com.facebook.react.viewmanagers.SecureViewManagerInterface

@ReactModule(name = SecureViewManager.NAME)
class SecureViewManager : ViewGroupManager<SecureView>(), SecureViewManagerInterface<SecureView> {
  private val mDelegate: ViewManagerDelegate<SecureView> = SecureViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SecureView> {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  override fun createViewInstance(context: ThemedReactContext): SecureView {
    return SecureView(context)
  }

  @ReactProp(name = "enable", defaultBoolean = true)
  override fun setEnable(view: SecureView, enable: Boolean) {
    view.isSecureEnabled = enable
  }

  companion object {
    const val NAME = "SecureView"
  }
}
