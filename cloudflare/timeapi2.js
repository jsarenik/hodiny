addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Respond to the request
 * @param {Request} request
 */
async function handleRequest(request) {
  d = new Date()
  return new Response(
    d.getTime(),
    {status: 200, headers: 
      {"content-type": "text/javascript"}
    }
  )
}
