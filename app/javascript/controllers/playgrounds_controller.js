import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = [
        "flagBooleanText",
        "flagBooleanInput",
        "flagBooleanInputDefault",
        "flagStringInput",
        "flagStringInputDefault",
        "flagStringText",
        "flagIntegerInput",
        "flagIntegerInputDefault",
        "flagIntegerText",
        "flagInput",
        "flagInputDefault",
        "flagText",
        "flagType"
    ];

    async submitForm(flagInput, flagInputDefault, flagText, flagType) {
        try {
            const response = await fetch(`playgrounds/get_flag?flag_type=${flagType}&flag_input=${flagInput}&flag_input_default=${flagInputDefault}`);
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.json();
            flagText.textContent = data.result.value;
        } catch (error) {
            console.error('There has been a problem with your fetch operation:', error);
        }

    }

    getStringFlag() {
        const flagInput = this.flagStringInputTarget.value;
        const flagInputDefault = this.flagStringInputDefaultTarget.value;
        const flagText = this.flagStringTextTarget;
        this.submitForm(flagInput, flagInputDefault, flagText, 's');
    }

    getBooleanFlag() {
        const flagInput = this.flagBooleanInputTarget.value;
        const flagInputDefault = this.flagBooleanInputDefaultTarget.value;
        const flagText = this.flagBooleanTextTarget;
        this.submitForm(flagInput, flagInputDefault, flagText, 'b');
    }

    getIntegerFlag() {
        const flagInput = this.flagIntegerInputTarget.value;
        const flagInputDefault = this.flagIntegerInputDefaultTarget.value;
        const flagText = this.flagIntegerTextTarget;
        this.submitForm(flagInput, flagInputDefault, flagText, 'i');
    }

    getFlag() {
        const flagInput = this.flagInputTarget.value;
        const flagInputDefault = this.flagInputDefaultTarget.value;
        const flagText = this.flagTextTarget;
        const type = this.flagTypeTarget.value;
        this.submitForm(flagInput, flagInputDefault, flagText, type);
    }
}