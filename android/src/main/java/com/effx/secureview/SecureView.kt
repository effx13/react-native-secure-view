package com.effx.secureview

import android.content.Context
import android.view.WindowManager
import android.widget.FrameLayout
import com.facebook.react.uimanager.ThemedReactContext

class SecureView(context: Context) : FrameLayout(context) {
  private var _isPreventingCapture: Boolean = false

  var isSecureEnabled: Boolean
    get() = _isPreventingCapture
    set(value) {
      if (_isPreventingCapture == value) return
      _isPreventingCapture = value

      try {
        val activity = (context as? ThemedReactContext)?.currentActivity
        activity?.window?.let { window ->
          if (value) {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
          } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
          }
        }
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }
}
