# Humanizer examples

Use these examples to calibrate transformations, not as phrases or topics to copy. Every rewrite must stay within the
facts, claims, uncertainty, and voice supplied by the input. If a natural rewrite appears to require a new detail,
experience, source, or opinion, leave the detail out.

## Contents

- Inflation and vague analysis
- Attribution, filler, and hedging
- Formulaic rhetoric and staccato structure
- Mechanical formatting, diff narration, and chat scaffolding
- Legitimate cadence, passive voice, and neutral prose to preserve

## Deflate promotional wording without deleting its claims

Before:
> Northbridge Library opened in 1998. It has 12,000 books, runs a Saturday reading group, and hosts community meetings.
> Nestled in the heart of town, it stands as a vibrant testament to the community's enduring commitment to knowledge,
> showcasing the power of public spaces.

After:
> Northbridge Library opened in 1998 in the center of town. It has 12,000 books, runs a Saturday reading group, and
> hosts community meetings. Those activities demonstrate the community's enduring commitment to knowledge and the
> power of public spaces.

Promotional wording does not authorize deleting its underlying claims. State them directly; remove one only when the
user authorizes substantive editing and the supplied context establishes that it is unsupported.

## Replace a vague participial tail with its supported claim

Before:
> The dashboard displays request latency, highlighting slow endpoints and providing teams with valuable visibility.

After:
> The dashboard displays request latency, highlights slow endpoints, and gives teams visibility into performance.

## Handle an unnamed authority without fabricating one

Before:
> Experts argue that the policy may improve retention.

After:
> Experts argue that the policy may improve retention.

If the source names those experts, name them. Otherwise retain the attribution rather than converting it into the
writer's own claim or adding a fictional citation.

## Simplify filler and stacked hedging

Before:
> At this point in time, it could potentially be argued that the system has the ability to reduce delays.

After:
> The system may reduce delays.

## Unpack formulaic rhetoric without losing the stated qualities

Before:
> Let's dive into CacheBox, a groundbreaking service that delivers speed, reliability, and scalability. It is not just
> a cache; it is the beating heart of the platform. The real question is whether teams can unlock its full potential.

After:
> CacheBox is a caching service that represents a major advance, delivers speed, reliability, and scalability, and is
> central to the platform. Teams still need to determine how fully they can use it.

`Groundbreaking` and `beating heart` are formulaic here, but they still assert major novelty and centrality. Express
those claims directly instead of deleting them.

## Replace a false range and staccato drama

Before:
> From the color of the button to the speed of the database, the redesign touches every layer. Fast. Focused.
> Future-ready. The update represents a pivotal shift in the evolving product landscape.

After:
> The redesign affects every layer, including button color and database speed. It makes the product faster, more
> focused, and ready for future needs, marking a major shift in its development.

## Flatten mechanical formatting only when prose reads better

Before:
> - **Access:** Members can enter the archive on weekdays.
> - **Loans:** Members may borrow three boxes for two weeks.
> - **Renewals:** Staff approve renewals by email.

After:
> Members can enter the archive on weekdays and borrow three boxes for two weeks. Staff approve renewals by email.

Keep a list when the items must be scanned, compared, or followed independently. Remove bold labels only when they add
no structure.

## Describe the current system instead of narrating its diff

Before:
> This helper was added to replace the previous loop over every item. It now uses a hash map, which makes lookups faster.

After:
> The helper uses a hash map instead of scanning every item, which makes lookups faster.

## Remove chat scaffolding from a document

Before:
> Of course! Here is an overview of the migration. It has three stages: export, validation, and cutover. I hope this
> helps. Let me know if you want more detail.

After:
> The migration has three stages: export, validation, and cutover.

Remove the chat wrapper and retain the actual document content unchanged.

## Preserve legitimate personal cadence

Before:
> I missed the train—again. Honestly, that was on me. The platform clock had been broken since Tuesday, and I knew it.

After:
> I missed the train—again. Honestly, that was on me. The platform clock had been broken since Tuesday, and I knew it.

A single em dash, candid aside, and irregular rhythm fit this personal passage. Changing them would flatten the voice
without removing a pattern cluster.

## Preserve justified passive voice

Before:
> The samples were stored at -80°C before analysis.

After:
> The samples were stored at -80°C before analysis.

The actor is irrelevant to this methods statement. Active voice would not make it clearer.

## Do not manufacture personality

Before:
> The trial produced three million lines of generated code. Developers reacted differently, and the implications remain
> unclear.

After:
> The trial produced three million lines of generated code. Developers reacted differently, and the implications remain
> unclear.

The passage is already direct and appropriately uncertain. Do not add first-person reaction, humor, conflict, or a
dramatic conclusion merely to make it feel human.
