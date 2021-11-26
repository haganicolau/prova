import treatFormErrors from '@/modules/account/common/treatFormErrors';
import alert from '@/modules/account/common/alert';

const defaultSuccessStatusCodes = [200, 201, 202, 203, 204];

function submit(element, request, options = {}) {
  const successStatusCodes = options.successStatusCodes ?? defaultSuccessStatusCodes;
  const elementToValidate = options.elementToValidate ?? element.$refs.form;
  const loadingProperty = options.loadingProperty ?? 'loading';
  const fieldsByPropertyName = options.fieldsByPropertyName ?? {};
  
  const successHandler = options.successHandler
    ?? function successHandler(response) {
      return defaultSuccess(response, successStatusCodes);
    };
    
  const errorHandler = options.errorHandler
    ?? function errorHandler(error) {
      return defaultError(element, error, fieldsByPropertyName);
    };

  const validatePromise = elementToValidate?.validate ?? function fakeValidate() {
    return new Promise(((myResolve) => { myResolve(true); }));
  };

  validatePromise().then(async (success) => {
    if (element[loadingProperty] || !success) {
      return;
    }

    element[loadingProperty] = true;
    element.$loading(true);
    
    request()
      .then((response) => {
        successHandler(response);
      }).catch((error) => {
        errorHandler(error);
      })
      .finally(() => {
        element[loadingProperty] = false;
        element.$loading(false);
      });
  });
  
}

function defaultSuccess(response, successStatusCodes = defaultSuccessStatusCodes) {
  if (successStatusCodes.indexOf(response.status) !== -1) {
    alert.fireAlert('Informações salvas com sucesso', {
      classes: 'alert-success',
      styles: 'background-color: #d4edda; border-color: #c3e6cb; color: #155724;',
      icon: 'fa-check-circle',
    });
  }
}

function defaultError(element, error, fieldsByPropertyName) {
  treatFormErrors.treatFormErrors(element, error, fieldsByPropertyName);
}
export default { submit, defaultSuccess };