import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TrialSectionComponent } from './trial-section.component';

describe('TrialSectionComponent', () => {
  let component: TrialSectionComponent;
  let fixture: ComponentFixture<TrialSectionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TrialSectionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TrialSectionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
