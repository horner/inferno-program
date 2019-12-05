# frozen_string_literal: true

module Inferno
  # FHIRModelsValidator extends BaseValidator to use the validation in fhir_models.
  # It passes the validation off to the correct model version.
  class FHIRModelsValidator
    def initialize; end

    def validate(resource, _fhir_version, profile_url = nil)
      if profile_url
        validator_klass = Inferno::ValidationUtil.definitions[profile_url]
        errors = validator_klass.validate_resource(resource)
        warnings = validator_klass.warnings
      else
        errors = resource.validate.collect { |k, v| "#{k}: #{v}" }
        warnings = []
      end

      {
        fatals: [],
        errors: errors.reject(&:empty?),
        warnings: warnings.reject(&:empty?),
        informations: []
      }
    end
  end
end
