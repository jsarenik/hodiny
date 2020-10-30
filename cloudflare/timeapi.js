addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Respond to the request
 * @param {Request} request
 */
async function handleRequest(request) {
  d = new Date()
  line = 'var dtest=new Date(), server=' + d.getTime()
  return new Response(
    line,
    {status: 200, headers: 
      {"content-type": "text/javascript"}
    }
  )
}
