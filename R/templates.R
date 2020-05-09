#' Applies a provided template string to a list of arguments.
#' Any argumements gives will be replaced in the template via placeholders wrapped in <<argument>>
#'
#' @param template A string with placeholders that can be replaced with the given arguments.
#' @param arguments Named list with values used for the template placeholders.
#' @return A string based on the template with the diferent argumetns applied.
applyTemplate <- function(template, arguments = list()) {
  do.call(
    glue::glue,
    modifyList(
      list(
          template,
          .open = "<<",
          .close = ">>"
      ),
      arguments
    )
  )
}

#' Get the full path for a default file template
#'
#' @param file Name of the file including the file extension.
getTemplate <- function(file) {
  paste0(system.file("pwa", package = "shiny.pwa"), "/", file)
}

#' Generates the folder structure required for the pwa files.
#'
#' @family fileGen
#' @seealso [createServiceWorker()], [createIcon()], [createOfflinePage()],
#'    [createManifest()]
createDirectories <- function() {
  dir.create("www/pwa", recursive = TRUE, showWarnings = FALSE)
}

#' Creates the service worker file based of the package template file.
#'
#' @family fileGen
#' @seealso [createDirectories()], [createIcon()], [createOfflinePage()],
#'    [createManifest()]
createServiceWorker <- function() {
  file.copy(getTemplate("service-worker.js"), paste0(getwd(), "/www/"))
}

#' Creates the pwa icon file based on the given path.
#'
#' @family fileGen
#' @seealso [createDirectories()], [createServiceWorker()],
#'    [createOfflinePage()], [createManifest()]
#'
#' @param icon Path to the icon used for PWA installations.
createIcon <- function(icon) {
  file.copy(icon, paste0(getwd(), "/www/pwa/icon.png"), overwrite = TRUE)
}


#' Creates the offline landing page.
#'
#' @family fileGen
#' @seealso [createDirectories()], [createServiceWorker()], [createIcon()],
#'    [createManifest()]
#'
#' @param title title of the page when the pwa is running in offline mode.
#' @param template HTML template to use. If null a default template is used.
#' @param offline_message An argument that can be used
#'    in the offline template to show a custom message.
createOfflinePage <- function(title, template, offline_message) {
  if(is.null(template)) {
    offline_arguments <- list(
      title = title,
      message = offline_message
    )

    writeLines(
      applyTemplate(
        read_file(getTemplate("offline.html")),
        offline_arguments
      ),
      paste0(getwd(), "/www/pwa/offline.html")
    )
  } else {
    file.copy(template, paste0(getwd(), "/www/pwa/offline.html"), overwrite = TRUE)
  }
}

#' Creates the manifest file.
#'
#' @family fileGen
#' @seealso [createDirectories()], [createServiceWorker()], [createIcon()],
#'    [createOfflinePage()]
#'
#' @param title title of the page when the pwa is running in offline mode.
#' @param start_url The ull url where the app is hosted.
#' @param color An argument that can be used in the
#'    offline template to show a custom message.
createManifest <- function(title, start_url, color) {
  manifest_arguments <- list(
    name = title,
    short_name = title,
    start_url = start_url,
    background_color = color,
    theme_color = color,
    description = title,
    icon = "icon.png"
  )
  writeLines(
    applyTemplate(
      read_file(getTemplate("manifest.json")),
      manifest_arguments
    ),
    paste0(getwd(), "/www/pwa/manifest.json")
  )
}