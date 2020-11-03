import axios from 'axios';
import {NativeModules} from 'react-native';
const {RNInspector} = NativeModules;

const http = axios.create({
  timeout: 5000,
});

// iOS workaround since we don't have okhttp to add an interceptor
if (RNInspector) {
  let requestId = 0;

  http.interceptors.request.use((config) => {
    // noinspection JSUnresolvedVariable
    const headers = {
      ...config.headers.common,
      ...config.headers[config.method],
      ...config.headers,
    };

    ['common', 'get', 'post', 'head', 'put', 'patch', 'delete'].forEach(
      (header) => {
        delete headers[header];
      },
    );

    // noinspection JSUndefinedPropertyAssignment
    config.uid = `${Date.now()}-${++requestId}`;

    // noinspection JSUnresolvedFunction,JSUnresolvedVariable
    RNInspector.sendRequestWithUID(config.uid, {
      url: config.url,
      method: config.method,
      headers: headers,
      body: config.data,
    });

    return config;
  });

  // for some reason there are headers like Set-Cookie that come as array
  function sanitize_headers(headers) {
    const m_headers = {};
    for (const [key, val] of Object.entries(headers)) {
      if (typeof val === 'string' || val instanceof String) {
        m_headers[key] = val;
      } else {
        m_headers[key] = JSON.stringify(val);
      }
    }
    return m_headers;
  }

  http.interceptors.response.use(
    (response) => {
      // noinspection JSUnresolvedFunction,JSUnresolvedVariable
      RNInspector.sendResponseWithUID(
        response.config.uid,
        {
          status: response.status,
          headers: sanitize_headers(response.headers),
        },
        response.data,
      );

      return response;
    },
    (error) => {
      const {config, response, message} = error;
      if (response) {
        // noinspection JSUnresolvedFunction
        RNInspector.sendResponseWithUID(
          config.uid,
          {
            status: response.status,
            headers: response.headers,
          },
          response.data,
        );
      } else {
        // noinspection JSUnresolvedFunction
        RNInspector.sendResponseWithUID(config.uid, {status: 500}, message);
      }
    },
  );
}

export default http;
