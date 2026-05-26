import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { apiInitializer } from "discourse/lib/api";
import DButton from "discourse/components/d-button";

class KodularFab extends Component {
  @service composer;
  @service router;
  @service currentUser;

  @action
  createTopic() {
    try {
      this.composer.openNewTopic();
    } catch {
      const btn = document.querySelector(
        "#create-topic, a.create.btn, button.create.btn"
      );
      btn ? btn.click() : this.router.transitionTo("/latest");
    }
  }

  <template>
    {{#if this.currentUser}}
      <div class="kodular-fab">
        <DButton
          class="kodular-fab__button btn-primary"
          @icon="plus"
          @action={{this.createTopic}}
          @title="Crear tema"
          aria-label="Crear tema"
        />
      </div>
    {{/if}}
  </template>
}

export default apiInitializer((api) => {
  api.renderInOutlet("above-footer", KodularFab);
});