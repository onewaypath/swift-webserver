<?php /* Template Name: User Form Handler */ 
  // error_reporting(E_ALL);
  // ini_set('display_errors', 1);
  // print_r($_GET);
  // print_r($_REQUEST);die;
  if (!isset($_GET["email"]) ) {
    header("Location: ".get_site_url());
    exit(0);
  }
  global $wpdb;
  $unique_user_id = false;

  if( !preg_match('~[0-9]~', $_GET["firstname"]) && !preg_match('~[0-9]~', $_GET["lastname"])){
    $url = 'https://onewaypath52346.api-us1.com';

    $params = array(
        // the API Key can be found on the "Your Settings" page under the "API" tab.
        // replace this with your API Key
        'api_key'      => 'a9351fb0bc084d89d9c962da1ac279f12d25b5fa49e0f804f4feb692279ec3d7ccc1602e',
        // this is the action that adds a contact
        'api_action'   => 'contact_add',
        'api_output'   => 'serialize',
    );

      // here we define the data we are posting in order to perform an update
    $post = array(
        'email'                    => $_GET["email"],
        'first_name'               => $_GET["firstname"],
        'last_name'                => $_GET["lastname"],
        'field[1]'                 => 'onewaypath.com/legal/', 
        'p[4]'                     => 1, // example list ID (REPLACE '123' WITH ACTUAL LIST ID, IE: p[5] = 5)
        'status[1]'                => 1,
        'responder[2]'             => 1
    );

    // This section takes the input fields and converts them to the proper format
    $query = "";
    foreach( $params as $key => $value ) $query .= urlencode($key) . '=' . urlencode($value) . '&';
    $query = rtrim($query, '& ');

    // This section takes the input data and converts it to the proper format
    $data = "";
    foreach( $post as $key => $value ) $data .= urlencode($key) . '=' . urlencode($value) . '&';
    $data = rtrim($data, '& ');

    // clean up the url
    $url = rtrim($url, '/ ');

    // This sample code uses the CURL library for php to establish a connection,
    // submit your request, and show (print out) the response.
    if ( !function_exists('curl_init') ) die('CURL not supported. (introduced in PHP 4.0.2)');

    // If JSON is used, check if json_decode is present (PHP 5.2.0+)
    if ( $params['api_output'] == 'json' && !function_exists('json_decode') ) {
        die('JSON not supported. (introduced in PHP 5.2.0)');
    }

    // define a final API request - GET
    $api = $url . '/admin/api.php?' . $query;

    $request = curl_init($api); // initiate curl object
    curl_setopt($request, CURLOPT_HEADER, 0); // set to 0 to eliminate header info from response
    curl_setopt($request, CURLOPT_RETURNTRANSFER, 1); // Returns response data instead of TRUE(1)
    curl_setopt($request, CURLOPT_POSTFIELDS, $data); // use HTTP POST to send form data
    //curl_setopt($request, CURLOPT_SSL_VERIFYPEER, FALSE); // uncomment if you get no gateway response and are using HTTPS
    curl_setopt($request, CURLOPT_FOLLOWLOCATION, true);

    $response = (string)curl_exec($request); // execute curl post and store results in $response

    // additional options may be required depending upon your server configuration
    // you can find documentation on curl options at http://www.php.net/curl_setopt
    curl_close($request); // close curl object
    if ( !$response ) {
        die('Nothing was returned. Do you have a connection to Email Marketing server?');
    }
    $result = unserialize($response);
    if (isset($result['subscriber_id'])) {
      $unique_user_id = $result['subscriber_id'];;
    }
  }
  wp_head();
?>
  <script>
    window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
    ga('create', 'UA-27239837-5', 'auto');
    <?php if($unique_user_id): ?>
      ga('set', 'userId', <?php echo $unique_user_id; ?>); // Set the user ID using signed-in user_id.
    <?php endif; ?>
    ga('send', 'pageview');
    setTimeout(function() {
      window.location.href = '<?php echo get_site_url(); ?>';
    },1000)
  </script>
  <script async src='https://www.google-analytics.com/analytics.js'></script>
