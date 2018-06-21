//
//  WindowController.swift
//  Twig
//
//  Created by Luka Kerr on 25/4/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    self.handleTransparentView()
    
    // Setup notification observer for preferences change
    NotificationCenter.receive("preferencesChanged", instance: self, selector: #selector(self.handleTransparentView))
    
    // set word count label in titlebar
    if let titlebarController = self.storyboard?.instantiateController(withIdentifier: "titlebarViewController") as? NSTitlebarAccessoryViewController {
      titlebarController.layoutAttribute = .right
      self.window?.addTitlebarAccessoryViewController(titlebarController)
      self.showWindow(self.window)
    }
  }
  
  // When preferences.transparentEditingView is changed this gets called
  // It sets the properties for the NSVisualEffectView based on the users preferences
  @objc private func handleTransparentView() {
    if let window = self.window {
      if preferences.transparentEditingView {
        window.styleMask.insert(.fullSizeContentView)
        window.isMovable = true
      } else {
        window.styleMask.remove(.fullSizeContentView)
      }
      if let splitViewController = window.contentViewController as? NSSplitViewController {
        if let markdownViewItem = splitViewController.splitViewItems.first {
          if let markdownViewController = markdownViewItem.viewController as? MarkdownViewController {
            markdownViewController.markdownTextView.textContainerInset.height = preferences.transparentEditingView ? 30.0 : 10.0
            markdownViewController.transparentView.isHidden = !preferences.transparentEditingView
          }
          
          if let previewViewController = splitViewController.splitViewItems.last {
            previewViewController.isCollapsed = !preferences.showPreviewOnStartup
          }
        }
      }
    }
  }

}