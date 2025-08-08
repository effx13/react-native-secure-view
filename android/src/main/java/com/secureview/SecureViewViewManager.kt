package com.secureview

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SecureViewViewManagerInterface
import com.facebook.react.viewmanagers.SecureViewViewManagerDelegate

@ReactModule(name = SecureViewViewManager.NAME)
class SecureViewViewManager : SimpleViewManager<SecureViewView>(),
  SecureViewViewManagerInterface<SecureViewView> {
  private val mDelegate: ViewManagerDelegate<SecureViewView>

  init {
    mDelegate = SecureViewViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<SecureViewView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): SecureViewView {
    return SecureViewView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: SecureViewView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "SecureViewView"
  }
}
